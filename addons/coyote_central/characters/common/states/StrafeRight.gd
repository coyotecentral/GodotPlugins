@tool
extends CharacterState

@export_group("Transitions")
@export var idle: State
@export var running: State
@export var strafe_left: State
@export var jump: State

func process_physics(delta: float) -> State:
	var vector: Vector2 = movement_controller.get_vector()
	var angle: float = rad_to_deg(vector.angle())

	if movement_controller.is_jump_just_pressed():
		return jump

	if vector.length() == 0:
		return idle

	# See: ./Idle.gd
	if (angle >= -180.0 and angle <= -133.0) or \
		(angle >= 133.0 and angle <= 180.0): 
		return strafe_left
	elif (angle > -133 and angle < -87) or \
		(angle > 46.0 and angle < 133.0):
		return running


	var direction = Vector3(vector.x, 0, vector.y)
	if direction.length() > 1:
		direction = direction.normalized()
	parent.position -= parent.global_transform.basis * (direction * parent.stats.move_speed * delta)
	parent.move_and_slide()
	return null
