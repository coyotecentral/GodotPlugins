@tool
extends Control

@export var btn_add: Button
@export var btn_scan: Button
@export var tree: Tree
var tree_root: TreeItem

@export var generation_controller: Control

const MAX_RECURSION: int = 100

@onready var fs = EditorInterface.get_resource_filesystem().get_filesystem()

var obj_files: Dictionary = {}

var selected_file: String = ""
var mesh: MeshInstance3D
var delta: float = 0.0

func _ready():
	btn_add.pressed.connect(_on_add_button_pressed)

	EditorInterface.get_resource_filesystem().filesystem_changed.connect(func():
		_scan_filesystem(EditorInterface.get_resource_filesystem().get_filesystem())
		_render_ui()
	)

	_reset_tree()
	btn_scan.pressed.connect(func():
		_scan_filesystem(EditorInterface.get_resource_filesystem().get_filesystem())
		_render_ui()
	)
	_scan_filesystem(fs)
	_render_ui()


func _process(d: float) -> void:
	delta = d
	var selected = tree.get_selected()
	if selected and selected.get_text(0).match("*.obj"):
		var fname = selected.get_text(0)
		var path = "res://%s/%s" % [obj_files[fname], fname]
		if path != selected_file:
			selected_file = path

func _on_add_button_pressed():
	var selected_paths: PackedStringArray = []

	var traverse = func(item: TreeItem, recurse: Callable):
		if not item:
			return
		
		if item.is_selected(0):
			# Concat the URI components to a single string with
			# a trailing "/"
			var m: String = ""
			for s in item.get_metadata(0):
				m = m + s + "/"
			selected_paths.append("%s%s" % [m, item.get_text(0)])

		for c in item.get_children():
			recurse.call(c, recurse)
	
	traverse.call(tree.get_root(), traverse)
	generation_controller.add_selection(selected_paths)


# Parses the selected object files to a dictionary
#
# TODO: this will cause conflicts if there is a duplicate file name
# to fix try setting the values  an array instead of single string
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
	tree_root = tree.create_item()
	tree_root.set_text(0, "res://")
	_render_dict(d, tree_root)

# Renders the dictionary to our Tree control node
func _render_dict(dict: Dictionary, item: TreeItem, url_segments: PackedStringArray = [], level: int = 0) -> void:
	if level >= MAX_RECURSION:
		printerr("Maximum recursion reached while rendering UI!!")
		return
	for key in dict.keys():
		if dict[key] is Dictionary:
			var c = tree.create_item(item)
			c.set_text(0, key)
			c.set_icon(0, EditorInterface.get_editor_theme().get_icon("Folder", "EditorIcons"))
			c.set_selectable(0, false)
			var new_url_segments := url_segments.duplicate()
			new_url_segments.append(key)
			_render_dict(dict[key], c, new_url_segments, level + 1)
		if dict[key] is Array:
			for v in dict[key]:
				var c = tree.create_item(item)
				c.set_text(0, v)
				c.set_icon(0, EditorInterface.get_editor_theme().get_icon("Mesh", "EditorIcons"))
				c.set_metadata(0, url_segments)


# Entrypoint for the file scan logic
# Scans the filesystem and filters out files for *.obj
func _scan_filesystem(dir: EditorFileSystemDirectory, level: int = 0):
	if level >= MAX_RECURSION:
		printerr("Maximum recursion reached!!")
		return

	for d in dir.get_subdir_count():
		var subdir = dir.get_subdir(d)
		_scan_filesystem(subdir, level + 1)
	for f in dir.get_file_count():
		if dir.get_file(f).match("*.obj"):

			# TODO: this will result in a bug where files with the same file name will only appear once
			# We don't actually need this intermediate representation since we can just store
			# the path as metadata for each item.

			# Paths starting with res:// is a given, so remove them. Also strip the last "/" at the end.
			obj_files[dir.get_file(f)] = dir.get_path().split("res://")[1].left(-1)

func _reset_tree():
	tree.clear()