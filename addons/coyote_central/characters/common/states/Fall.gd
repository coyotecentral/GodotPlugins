extends CharacterState

@export_group("Transitions")
@export var idle: State
@export var running: State
@export var strafe_left: State
@export var strafe_right: State

func process_physics(delta: float) -> State:

	parent.velocity.y -= parent.stats.fall_gravity * delta
	# var movement = movement_controller.get_vector().x * parent.stats.float_speed
	# parent.velocity.x = -movement
	parent.move_and_slide()

	var vector = movement_controller.get_vector()
	if parent.is_on_floor():
		if vector.length():
			return running
		else:
			return idle
	return null
