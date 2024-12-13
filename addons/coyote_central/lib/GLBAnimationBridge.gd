# A proxy to access the animations of imported GLB files. The script assumes the
# imported GLB has an AnimationPlayer node that is a direct descendant of the
# root node. Otherwise, a custom path may be defined.
@tool
extends Node
class_name GLBAnimationBridge

@export var use_custom_path: bool = false :
	set(v):
		use_custom_path = v
		notify_property_list_changed()

# See: https://docs.godotengine.org/en/stable/classes/class_nodepath.html
var _animation_player_path: NodePath = "AnimationPlayer"

@export var model: Node = null:
	set(v):
		model = v
		_animation_player = _retrieve_animation_player(model)
		_set_current_animation_hint()

var _animation_player: AnimationPlayer

func _retrieve_animation_player(node: Node) -> AnimationPlayer:
	return model.get_node(_animation_player_path)

# EditorInspector properties
func _get_property_list():
	var props = []

	props.append({
		"name": "current_animation",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": _current_animation_hint
	})
	props.append({
		"name": "speed_scale",
		"type": TYPE_FLOAT,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "-4,4",
	})

	if use_custom_path:
		props.append({
			"name": "path",
			"type": TYPE_STRING,
		})

	return props

func _property_can_revert(property: StringName) -> bool:
	if property == "current_animation":
		return true
	if property == "speed_scale":
		return true
	return false

func _property_get_revert(property: StringName) -> Variant:
	if property == "current_animation":
		return ""
	if property == "speed_scale":
		return 1.0
	return null

func _get(property):
	match(property):
		"path":
			return _animation_player_path
		"current_animation":
			return _animation_player.current_animation
		"speed_scale":
			return _animation_player.speed_scale


func _set(property, value):
	match(property):
		"path":
			_animation_player_path = value
		"current_animation":
			if(value):
				_animation_player.current_animation = value
		"speed_scale":
			if(value):
				_animation_player.speed_scale = value


# AnimationMixer methods
var _current_animation_hint = ""
func get_animation_list() -> PackedStringArray:
	return _animation_player.get_animation_list()
func _set_current_animation_hint():
	var animation_list = get_animation_list()
	var size: int = animation_list.size()
	for i in range(0, size):
		_current_animation_hint += "%s" % animation_list[i]
		if i < size - 1:
			_current_animation_hint += ","

# AnimationPlayer methods