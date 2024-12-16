@tool
extends CharacterState

@export_group("Transitions")
@export var running: State
@export var strafe_right: State
@export var strafe_left: State

func process_physics(delta: float) -> State:
	var vector = movement_controller.get_vector()
	if vector.y != 0:
		return running
	if vector.x < 0:
		return strafe_left
	if vector.x > 0:
		return strafe_right
	return null
