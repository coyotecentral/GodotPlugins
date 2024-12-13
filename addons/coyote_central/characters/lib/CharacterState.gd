@tool
extends State
class_name CharacterState

var movement_controller: MovementController
var animations: AnimationPlayer :
	set(v):
		animations = v
		_anim_hint_str = AnimationPlayerHelpers.get_anim_list_hint_str(v)
	get:
		return animations

var _animation_name: String = ""
var _anim_hint_str: String = ""

func _get_property_list() -> Array:
	var props = []

	props.append({
		"name": "animation",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": _anim_hint_str
	})

	return props

func _get(property) -> Variant:
	match(property):
		"animation":
			return _animation_name
	return null

func _set(property, value: Variant) -> bool:
	match(property):
		"animation":
			_animation_name = value
			return true
	return false

func enter() -> void:
	# Start playing a new animation, if applicable
	animations.play(_animation_name)