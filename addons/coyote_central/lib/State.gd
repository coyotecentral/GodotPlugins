# This class serves as an abstract class from which all state classes inherit from.
# State classes define the transitions between states.

extends Node
class_name State

var parent

func init() -> void:
	pass

func enter() -> void:
	pass

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:
	return null

func process_frame(delta: float) -> State:
	return null