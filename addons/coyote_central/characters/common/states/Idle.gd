@tool
extends CharacterState

@export_group("Transitions")
@export var running: State
@export var strafe_right: State
@export var strafe_left: State
@export var fall: State
@export var jump: State

func process_physics(delta: float) -> State:
	var vector = movement_controller.get_vector()
	var angle = rad_to_deg(vector.angle())

	if not parent.is_on_floor():
		return fall
	
	if movement_controller.is_jump_just_pressed():
		return jump

	if vector.length() > 0:
		# Idk why, but when using arrow keys/keyboard, the vector angle tends to be off.
		# Maybe because of rounding errors? Either way, here's some weirdo magic
		# numbers. Maybe add in some settings for this at some point.
		if (angle >= -180.0 and angle <= -133.0) or \
			(angle >= 133.0 and angle <= 180.0): 
			return strafe_left
		elif (angle >= -45 and angle <= 0) or \
			(angle >= 0 and angle <= 46):
			return strafe_right
		else:
			return running
	
		

	return null
