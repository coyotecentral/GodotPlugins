extends Resource
class_name CharacterStats

@export_group("Movement")
@export var move_speed: float = 10.0

@export_group("Jumping")
@export var jump_height := 4.0
@export var float_speed := 3.0
@export var jump_time_to_peak := 0.5
@export var jump_time_to_fall := 0.4
@export var coyote_time := 0.05

var jump_velocity: float :
	get:
		return ((2.0 * jump_height) / jump_time_to_peak)

var jump_gravity: float :
	get:
		return ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0

var fall_gravity: float :
	get:
		return ((-2.0 * jump_height) / (jump_time_to_fall * jump_time_to_fall)) * -1.0