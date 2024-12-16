@tool
extends CharacterState

@export_group("Transitions")
@export var idle: State
@export var strafe_left: State
@export var strafe_right: State


func process_physics(delta: float) -> State:
	var vector = movement_controller.get_vector()
	if vector.y == 0:
		return idle
	if vector.x > 0:
		return strafe_right
	elif vector.x < 0:
		return strafe_left

	parent.position.z -= vector.y * parent.stats.move_speed * delta
	return null