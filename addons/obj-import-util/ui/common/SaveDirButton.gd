@tool
extends Button

@onready var _file_dialogue: FileDialog = $FileDialog
@export var file_name: String = ""

signal dir_selected(dir: String)
signal file_selected(path: String)

func _ready() -> void:
	icon = EditorInterface.get_editor_theme().get_icon("Folder", "EditorIcons")
	pressed.connect(func():
		_file_dialogue.visible = true

		# TODO: support file names with multiple "." characters
		_file_dialogue.current_file = "%s" % file_name.split(".")[-1]
		)
	
	_file_dialogue.dir_selected.connect(dir_selected.emit)
	_file_dialogue.file_selected.connect(file_selected.emit)