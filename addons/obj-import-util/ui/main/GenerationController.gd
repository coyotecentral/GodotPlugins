@tool
extends VBoxContainer

@export var btn_dir_select: Button
@export var btn_dir_label: LineEdit

var config: Dictionary = {
	"obj_files": [],
	"output": {
		"dir": "",
	}
}

func _ready():
	btn_dir_select.dir_selected.connect(_update_dir)

func _update_dir(value: String) -> void:
	config["output"]["dir"] = value
	btn_dir_label.text = config["output"]["dir"]

func _generate_all():
	for f in config["obj_files"]:
		_save_scene(f.split("/")[-1])

func _save_scene(fname: String):
	var scene = PackedScene.new()

	var root = _get_generated_root_node()
	scene.pack(root)

	ResourceSaver.save(scene, "%s/%s" % [config["output"]["dir"], fname])

func _get_generated_root_node() -> Node3D:
	return Node3D.new()