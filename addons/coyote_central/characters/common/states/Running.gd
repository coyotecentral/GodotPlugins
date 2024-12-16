@tool
extends CharacterState

@export_group("Transitions")
@export var idle: State
@export var strafe_left: State
@export var strafe_right: State


func process_physics(delta: float) -> State:
	var vector: Vector2 = movement_controller.get_vector()
	var angle: float = rad_to_deg(vector.angle())

	if vector.length() == 0:
		return idle

	# See: ./Idle.gd
	if (angle >= -180.0 and angle < -133.13) or \
		(angle >= 133.0 and angle <= 180.0): 
		return strafe_left
	elif (angle >= -45 and angle <= 0) or \
		(angle >= 0 and angle <= 46):
		return strafe_right


	var direction = Vector3(vector.x, 0, vector.y)
	if direction.length() > 1:
		direction = direction.normalized()
	parent.position -= parent.global_transform.basis * (direction * parent.stats.move_speed * delta)
	return null