@tool
extends CharacterState

@export_group("Transitions")
@export var idle: State
@export var running: State
@export var strafe_right: State
@export var jump: State

func process_physics(delta: float) -> State:
	var vector = movement_controller.get_vector()
	var angle = rad_to_deg(vector.angle())

	if movement_controller.is_jump_just_pressed():
		return jump

	# See: ./Idle.gd
	if (angle >= -45 and angle <= 0) or \
		(angle >= 0 and angle <= 46):
		return strafe_right
	elif (angle > -133.13 and angle < -87) or \
		(angle > 46.0 and angle < 133.0):
		return running
	
	if vector.length() == 0:
		return idle

	var direction = Vector3(vector.x, 0, vector.y)
	if direction.length() > 1:
		direction = direction.normalized()
	parent.position -= parent.global_transform.basis * (direction * parent.stats.move_speed * delta)
	parent.move_and_slide()
	return null