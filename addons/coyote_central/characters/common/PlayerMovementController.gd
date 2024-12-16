extends MovementController

func get_vector() -> Vector2:
	return Input.get_vector("left", "right", "up", "down")