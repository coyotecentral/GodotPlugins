@tool
extends Control

@export var btn: Button
@export var tree: Tree
const MAX_RECURSION: int = 100

@onready var fs = EditorInterface.get_resource_filesystem().get_filesystem()

var obj_files: Dictionary = {}


func _ready():
	_reset_tree()
	btn.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	_reset_tree()
	_scan_filesystem(fs)
	_render_ui()

func _parse_obj_files_to_dict() -> Dictionary:
	var tree_repr: Dictionary = {}
	for key in obj_files.keys():
		var path = obj_files[key]
		var segments: Array = path.split("/")

		# Traverse the dictionary
		var node = tree_repr
		for s in segments:
			if not node.has(s):
				node[s] = {}
			node = node[s]
		if node.has(segments[-1]):
			node[segments[-1]].push_back(key)
		else:
			node[segments[-1]] = [key]
	return tree_repr

func _render_ui():
	_reset_tree()
	var d = _parse_obj_files_to_dict()
	var root = tree.create_item()
	root.set_text(0, "res://")
	_render_dict(d, root)

func _render_dict(dict: Dictionary, item: TreeItem, level: int = 0) -> void:
	if level >= MAX_RECURSION:
		printerr("Maximum recursion reached while rendering UI!!")
		return
	for key in dict.keys():
		if dict[key] is Dictionary:
			var c = tree.create_item(item)
			c.set_text(0, key)
			_render_dict(dict[key], c, level + 1)
		if dict[key] is Array:
			for v in dict[key]:
				var c = tree.create_item(item)
				c.set_text(0, v)


func _scan_filesystem(dir: EditorFileSystemDirectory, level: int = 0):
	if level >= MAX_RECURSION:
		printerr("Maximum recursion reached!!")
		return

	for d in dir.get_subdir_count():
		var subdir = dir.get_subdir(d)
		_scan_filesystem(subdir, level + 1)
	for f in dir.get_file_count():
		if dir.get_file(f).match("*.obj"):
			# Paths starting with res:// is a given, so remove them. Also strip the last "/" at the end.
			obj_files[dir.get_file(f)] = dir.get_path().split("res://")[1].left(-1)

func _reset_tree():
	tree.clear()