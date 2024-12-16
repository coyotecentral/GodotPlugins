@tool
extends CharacterState

@export_group("Transitions")
@export var idle: State
@export var running: State
@export var strafe_left: State

func process_physics(delta: float) -> State:
	var vector = movement_controller.get_vector()
	if vector.x < 0:
		return strafe_left
	if vector.x == 0 and vector.y != 0:
		return running
	if vector.length() == 0:
		return idle

	var direction = Vector3(vector.x, 0, vector.y)
	if direction.length() > 1:
		direction = direction.normalized()
	parent.position -= direction * parent.stats.move_speed * delta
	return null