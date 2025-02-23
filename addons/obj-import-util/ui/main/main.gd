@tool
extends Control

@export var file_explorer: Control
@export var generation_controller: Control

const MAX_RECURSION: int = 100

@onready var fs = EditorInterface.get_resource_filesystem().get_filesystem()

var filtered_fs: Dictionary = {
	"dirs": {},
	"files": []
}

var export_opts: Dictionary = {
	"files": PackedStringArray([]),
	"output": {
		"dir": ""
	},
	"dry_run": true
}

func _ready():
	_recursively_scan_dir(fs)
	$MarginContainer/HBoxContainer/FileExplorer.render(filtered_fs)

	EditorInterface.get_resource_filesystem().filesystem_changed.connect(func():
		_recursively_scan_dir(fs)
	)
	file_explorer.add_selection.connect(_add_selection)

	generation_controller.generate_all.connect(_generate_all)
	generation_controller.dir_selected.connect(_set_out_dir)

	file_explorer.render(filtered_fs)

func _set_out_dir(path: String):
	export_opts["output"]["dir"] = path

func _on_add_button_pressed():
	var selected_paths = file_explorer.get_selection()
	print(selected_paths)

func _add_selection(array: PackedStringArray) -> void:
	for i in array:
		if not export_opts["files"].has(i):
			export_opts["files"].append(i)
	_render_files_for_export()

func _remove_selection(path: String) -> void:
	var idx = export_opts["files"].find(path)
	if idx >= 0:
		export_opts["files"].remove_at(idx)
	_render_files_for_export()

func _clear_selection() -> void:
	export_opts["files"] = PackedStringArray([])
	_render_files_for_export()

# Reset selection, state, etc
func reset() -> void:
	_clear_selection()

func _render_files_for_export() -> void:
	var ilist: Control = $MarginContainer/HBoxContainer/SelectedFiles/ScrollContainer/ItemList
	var empty_panel: Control = $MarginContainer/HBoxContainer/SelectedFiles/Empty
	if export_opts["files"].size() > 0:
		empty_panel.visible = false
	else:
		empty_panel.visible = true
	
	# TOOD: replace this lol
	for c in ilist.get_children():
		c.queue_free()

	for i in export_opts["files"]:
		var c = load("res://addons/obj-import-util/ui/main/ExportItem.tscn").instantiate()
		c.file_path = i
		c.removed.connect(func():
			_remove_selection(i)
		)
		ilist.add_child(c)

func _recursively_scan_dir(dir: EditorFileSystemDirectory) -> void:
	for d in dir.get_subdir_count():
		var subdir = dir.get_subdir(d)
		_recursively_scan_dir(subdir)
	for f in dir.get_file_count():
		if dir.get_file(f).match("*.obj"):
			var fpath = "%s%s" % [dir.get_path().split("res://")[1], dir.get_file(f)]
			_parse_path(fpath)

# Parse a path into the filtered_fs dictonary.
func _parse_path(fpath: String) -> void:

	# Split the path into its segments
	var segments = fpath.split("/")

	# If we only have 1 item and it's a .obj file, then add it to the root dir
	if segments.size() == 1 and segments[0].match("*.obj"):
		filtered_fs["files"].append(segments[0])
		print(segments)
		return

	# Otherwise begin traversing the filtered_fs dict
	var dict = filtered_fs["dirs"]

	# Iterate over each segment
	for s in segments.size():

		# If it's not the terminal segment
		if not segments[s].match("*.obj"):
			# Add a new directory object if there isn't one already
			if not dict.has(segments[s]):
				dict[segments[s]] = {
					"files": [],
					"dirs": {}
				}
			# If we have more directories to traverse, keep going
			if s < segments.size() - 2:
				dict = dict[segments[s]]["dirs"]
			else:
				# Otherwise, we've reached the directory of where the file will go
				dict = dict[segments[s]]
		else:
			# Add this file to the list contained in this directory
			dict["files"].append(segments[s])


func _generate(idx: int) -> void:

	var obj_path = export_opts["files"][idx]
	var fname = obj_path.split("/")[-1].split(".")[0]
	var scene = PackedScene.new()

	var new_fpath = "%s/%s.tscn" % [export_opts["output"]["dir"], fname]
	var root = Node3D.new()
	scene.pack(root)

	if export_opts["dry_run"]:
		print(new_fpath)
	else:
		ResourceSaver.save(scene, new_fpath)

func _generate_all():
	for idx in export_opts["files"].size():
		_generate(idx)
