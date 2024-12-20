@tool
extends State
class_name CharacterState

var movement_controller: MovementController

var _anim_state_machine: AnimationNodeStateMachinePlayback
@export var animation_tree_node: String

func _ready() -> void:
	if not get_parent() is CharacterStateMachine:
		printerr("Class CharacterState expects parent node to be type CharacterStateMachine!")
	var parent: CharacterStateMachine = get_parent()
	movement_controller = parent.movement_controller

func init():
	pass

# Old cod that provides tooling for animation players. Maybe use in 2D plugin.
# var _animation_name: String = ""
# var _anim_hint_str: String = ""
# func _get_property_list() -> Array:
# 	var props = []
# 
# 	props.append({
# 		"name": "animation",
# 		"type": TYPE_STRING,
# 		"hint": PROPERTY_HINT_ENUM,
# 		"hint_string": _anim_hint_str
# 	})
# 
# 	return props
# 
# func _get(property) -> Variant:
# 	match(property):
# 		"animation":
# 			return _animation_name
# 	return null
# 
# func _set(property, value: Variant) -> bool:
# 	match(property):
# 		"animation":
# 			_animation_name = value
# 			return true
# 	return false

func enter() -> void:
	# Start playing a new animation, if applicable
	# _anim_state_machine.travel(_animation_name)
	_anim_state_machine.travel(animation_tree_node)