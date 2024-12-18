@tool
extends CharacterState

@export_group("Transitions")
@export var fall_state: State

func enter():
	super()
	parent.velocity.y = parent.stats.jump_velocity

func process_physics(delta: float) -> State:
	if not movement_controller.is_jump_pressed():
		parent.velocity.y *= 0.6 # Short jump falloff
		return fall_state
	
	parent.velocity.y += parent.stats.jump_gravity * delta
	# var movement = movement_controller.get_vector().x * parent.stats.float_speed
	# parent.velocity.x = movement
	parent.move_and_slide()

	if parent.velocity.y >= 0.0:
		return fall_state
	return null
