@tool
extends Control

@export var file_path: String = "":
	set(v):
		file_path = v
		_file_name = file_path.split("/")[-1]
	get:
		return file_path
@onready var _title_container: Control = $VBoxContainer/TitleContainer
@onready var _directory_opts: Control = $VBoxContainer/Opts/VBoxContainer/Output/Directory

var _file_name: String = ""

var form_state: Dictionary = {
	"generation": {
		"StaticBody3D": false,
		"RigidBody3D": false,
		"Area3D": false,
		"CollisionShape3D": false
	},
	"output": {
		"dir": "",
		"fname": ""
	}
}

func _ready() -> void:
	_render_title()
	if not _title_container:
		_title_container = $VBoxContainer/TitleContainer
	
	_directory_opts.get_node("SaveButton").file_selected.connect(print)
	
	# Set the output file name to be the same as the input
	form_state["output"]["fname"] = _file_name

func _process(delta: float) -> void:
	_render_title()

func _render_title():
	_title_container.get_node("MarginContainer/Label").text = file_path
	$VBoxContainer/Opts/VBoxContainer/Output/Directory/SaveButton.file_name = _file_name.split(".")[0]

func _render_form_state() -> void:
	_directory_opts.get_node("LineEdit").text = form_state["output"]["dir"]