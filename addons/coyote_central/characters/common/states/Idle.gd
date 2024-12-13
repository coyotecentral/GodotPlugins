@tool
extends CharacterState

func process_physics(delta: float) -> State:
	# Loop the animation if the state is the same
	if not animations.is_playing():
		animations.play(_animation_name)
	return null
