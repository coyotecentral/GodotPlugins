# This is the base class for all StateMachines.
# It serves as an abstract class from which other state machines can derive from.
# This class defines handling transitions between State objects, and processining
# the physics, unhandled input, and frame callbacks.

extends Node
class_name StateMachine

@export var starting_state: State
var current_state: State
var parent

# Initialize the node for a given parent
func init(p) -> void:
	parent = p

	for child in get_children():
		child.parent = p
	
	change_state(starting_state)

func change_state(next_state: State) -> void:
	if current_state:
		current_state.exit()
	current_state = next_state
	current_state.enter()

func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)

func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)

func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)