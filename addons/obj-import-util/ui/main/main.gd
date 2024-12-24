@tool
extends Control

@export var btn_add: Button
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
	}
}

func _ready():
	_recursively_scan_dir(fs)
	$MarginContainer/HBoxContainer/FileExplorer.render(filtered_fs)

	EditorInterface.get_resource_filesystem().filesystem_changed.connect(func():
		_recursively_scan_dir(fs)
	)
	file_explorer.render(filtered_fs)

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
	
	#Z traverse.call(tree.get_root(), traverse)
	# generation_controller.add_selection(selected_paths)
	_add_selection(selected_paths)

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
		c.file_path= i
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

func _parse_path(fpath: String) -> void:
	var segments = fpath.split("/")

	if segments.size() == 1 and segments[0].match("*.obj"):
		filtered_fs["files"].append(segments[0])
		print(segments)
		return

	var dict = filtered_fs["dirs"]
	for s in segments.size():
		if not segments[s].match("*.obj"):
			if not dict.has(segments[s]):
				dict [segments[s]] = {
					"files": [],
					"dirs": {}
				}
			if s < segments.size() - 2:
				dict = dict[segments[s]]["dirs"]
			else:
				dict = dict[segments[s]]
		else:
			dict["files"].append(segments[s])