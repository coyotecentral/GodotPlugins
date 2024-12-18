extends MovementController

func get_vector() -> Vector2:
	return Input.get_vector("left", "right", "up", "down")

func is_jump_just_pressed() -> bool:
	return Input.is_action_just_pressed("jump")

func is_jump_pressed() -> bool:
	return Input.is_action_pressed("jump")