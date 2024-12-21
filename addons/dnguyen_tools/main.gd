@tool
extends Control

@export var btn: Button
@export var tree: Tree
@export var sub_viewport: SubViewport
const MAX_RECURSION: int = 100

@onready var fs = EditorInterface.get_resource_filesystem().get_filesystem()

var obj_files: Dictionary = {}

var selected_file: String = ""
var mesh: MeshInstance3D
var delta: float = 0.0


func _ready():
	btn.pressed.connect(_on_button_pressed)
	sub_viewport.get_parent().gui_input.connect(_handle_sub_vp_gui_input)

	_reset_tree()
	_scan_filesystem(fs)
	_render_ui()


# TODO: Fix this jank
func _handle_sub_vp_gui_input(event: InputEvent) -> void:
	if not mesh:
		return
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			mesh.global_basis = mesh.global_basis.rotated(Vector3.UP, event.relative.x * delta)
			mesh.global_basis = mesh.global_basis.rotated(Vector3.LEFT, event.relative.y * delta)
			sub_viewport.get_camera_3d().look_at(mesh.get_aabb().get_center())

func _process(d: float) -> void:
	delta = d
	var selected = tree.get_selected()
	if selected and selected.get_text(0).match("*.obj"):
		var fname = selected.get_text(0)
		var path = "res://%s/%s" % [obj_files[fname], fname]
		if path != selected_file:
			selected_file = path
			_clear_sub_viewport()
			_render_to_sub_viewport(path)

# Add to export
func _on_button_pressed():
	pass

func _render_to_sub_viewport(file: String):
	var array_mesh: ArrayMesh = load(file)
	mesh = MeshInstance3D.new()
	mesh.mesh = array_mesh
	sub_viewport.add_child(mesh)
	sub_viewport.get_camera_3d().look_at(mesh.get_aabb().get_center())


func _clear_sub_viewport():
	if mesh:
		mesh.queue_free()
	mesh = null

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