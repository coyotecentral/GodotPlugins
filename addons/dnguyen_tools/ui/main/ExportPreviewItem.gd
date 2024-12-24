@tool
extends Control

@export var file_path: String = "":
	set(v):
		file_path = v
		_file_name = file_path.split("/")[-1]
	get:
		return file_path
@onready var _title_container: Control = $VBoxContainer/TitleContainer
@onready var _directory_opts: Control = $VBoxContainer/Opts/VBoxContainer/Output/VBoxContainer/Directory
@onready var _mesh_preview_texture: TextureRect = $VBoxContainer/Opts/VBoxContainer/Generation/HBoxContainer/TextureRect

var _file_name: String = ""
var _is_collapsed = false

var form_state: Dictionary = {
	"generation": {
		"StaticBody3D": false,
		"RigidBody3D": false,
		"Area3D": false,
		"CollisionShape3D": false
	},
	"material": {
		
	},
	"output": {
		"dir": "",
		"fname": ""
	}
}

signal removed

func _ready() -> void:
	_render_title_bar()
	if not _title_container:
		_title_container = $VBoxContainer/TitleContainer
	
	_title_container.get_node("MarginContainer/HBoxContainer/Delete").pressed.connect(removed.emit)
	_title_container.get_node("MarginContainer/HBoxContainer/Collapse").pressed.connect(func():
		_is_collapsed = !_is_collapsed
		$VBoxContainer/Opts.visible = !_is_collapsed
	)

	$VBoxContainer/Opts.visible = !_is_collapsed
	
	_directory_opts.get_node("SaveButton").file_selected.connect(print)
	
	# Set the output file name to be the same as the input
	form_state["output"]["fname"] = _file_name

	_create_preview_texture()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MASK_RIGHT and \
			$VBoxContainer/Opts\
				.get_global_rect()\
				.has_point(get_global_mouse_position()) and \
			not $VBoxContainer/Opts/VBoxContainer/Output/VBoxContainer/Directory/LineEdit\
				.get_global_rect()\
				.has_point(get_global_mouse_position()):
			# TODO: figure out why this menu sometimes just disappears...
			$RightClickMenu.position = DisplayServer.mouse_get_position()
			$RightClickMenu.popup()

func _create_preview_texture():
	var file := load("res://%s" % file_path)
	var texture: Array[Texture2D] = EditorInterface.make_mesh_previews([file], 128)
	_mesh_preview_texture.texture = texture[0]

func _process(delta: float) -> void:
	_render_title_bar()

func _render_title_bar():
	var theme = EditorInterface.get_editor_theme()
	_title_container.get_node("MarginContainer/HBoxContainer/Label").text = file_path
	_title_container.get_node("MarginContainer/HBoxContainer/Delete").icon = theme.get_icon("Remove", "EditorIcons")
	if _is_collapsed:
		_title_container.get_node("MarginContainer/HBoxContainer/Collapse").icon = theme.get_icon("Forward", "EditorIcons")
	else:
		_title_container.get_node("MarginContainer/HBoxContainer/Collapse").icon = theme.get_icon("Collapse", "EditorIcons")


func _render_form_state() -> void:
	_directory_opts.get_node("LineEdit").text = form_state["output"]["dir"]
	$VBoxContainer/Opts/VBoxContainer/Output/Directory/SaveButton.file_name = form_state["output"]["fname"].split(".")[0]