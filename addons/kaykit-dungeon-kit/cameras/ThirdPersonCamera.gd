@tool
extends Camera3D
class_name ThirdPersonCamera3D

@export var target: Node3D :
	set(v):
		target = v
		update_configuration_warnings()

@export var max_follow_distance = 1.0
@export var follow_speed = 5.0
# In Euler angles
@export var max_rotaion_diff = 35.0

@export_group("Mouse Control")
@export var use_mouse: bool = false
@export_range(0, 1) var mouse_x_sensitivity = 0.1
var _delta: float = 0.0

var camera_state = "follow"

func _ready():
	if not target:
		update_configuration_warnings()

func _get_configuration_warnings() -> PackedStringArray:
	if not target:
		return ["No target Node3D assigned!"]
	else:
		return []

func get_camera_velocity(d: float):
	return 5.0 * d / max_follow_distance

func rotate_camera(relative: float, sensitivity: float) -> void:
	camera_state = "rotate"
	var target_parent = target.get_parent().get_parent()
	target_parent.rotation.y -= relative * (PI * sensitivity / 2) * _delta

func _input(event: InputEvent):
	if not use_mouse:
		return
	if event is InputEventMouseMotion:
		rotate_camera(event.relative.x, mouse_x_sensitivity * 0.125)
	else:
		camera_state = "follow"

func _physics_process(delta: float) -> void:
	_delta = delta
	if Engine.is_editor_hint() and not target:
		return
	
	if not Engine.is_editor_hint():
		var look = Input.get_axis("look_left", "look_right")
		if look != 0:
			rotate_camera(look, 2)


	var distance = (global_position - target.global_position).length()
	if camera_state == "follow":
		var target_basis = Basis(target.global_transform.basis)
		# TODO:
		# Calculate the difference between the angles of this basis and the target's, then
		# adjust the speed to compensate for the rotation
		global_transform.basis = global_transform.basis.slerp(target_basis.orthonormalized(), PI * delta)
		position = position.move_toward(target.global_position, get_camera_velocity(distance) * delta)
	if camera_state == "rotate":
		var target_basis = Basis(target.global_transform.basis)
		global_transform.basis = target_basis
		position = position.move_toward(target.global_position, get_camera_velocity(distance) * delta)