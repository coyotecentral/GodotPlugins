@tool
extends Control

signal _changed(key: String, value: Variant)
signal removed

@export var file_path: String = "" :
	set(v):
		file_path = v
		_file_name = file_path.split("/")[-1]
	get:
		return file_path


var _file_name: String = ""

func _ready():
	$Label.text = file_path

	_changed.connect(func(key, value):
		if key == "file_path":
			$Label.text = file_path
	)

	$DeleteButton.pressed.connect(removed.emit)
