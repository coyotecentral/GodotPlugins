@tool
extends VBoxContainer

@export var btn_dir_select: Button
@export var btn_dir_label: LineEdit

signal dir_selected(path: String)
signal generate_all()

func _ready():
	btn_dir_select.dir_selected.connect(dir_selected.emit)
	$Btn_Generate.pressed.connect(generate_all.emit)