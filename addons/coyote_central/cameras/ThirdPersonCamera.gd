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

func _input(event: InputEvent):
	if not use_mouse:
		return
	if event is InputEventMouseMotion:
		camera_state = "rotate"
		var target_parent = target.get_parent()
		target_parent.rotation.y -= event.relative.y * PI  * _delta
	else:
		camera_state = "follow"

func _physics_process(delta: float) -> void:
	_delta = delta
	if Engine.is_editor_hint() and not target:
		return
	
	if camera_state == "follow":
		var distance = (global_position - target.global_position).length()
		var target_basis = Basis(target.global_transform.basis)
		# TODO:
		# Calculate the difference between the angles of this basis and the target's, then
		# adjust the speed to compensate for the rotation
		global_transform.basis = global_transform.basis.slerp(target_basis.orthonormalized(), PI * delta)
		position = position.move_toward(target.global_position, get_camera_velocity(distance) * delta)
	if camera_state == "rotate":
		var target_basis = Basis(target.global_transform.basis)
		global_transform.basis = target_basis
		position = target.global_position