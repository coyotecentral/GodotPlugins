@tool
extends EditorPlugin

const MainWindow = preload("res://addons/obj-import-util/ui/main/main_window.tscn")

var i_main_window: Window

func _enter_tree() -> void:
	add_tool_menu_item("Obj Import Util", func():
		if not i_main_window:
			i_main_window = MainWindow.instantiate()
			EditorInterface.get_base_control().add_child(i_main_window)

		i_main_window.close_requested.connect(i_main_window.hide)
		i_main_window.show()
	)

func _exit_tree() -> void:
	if i_main_window:
		i_main_window.queue_free()
		remove_tool_menu_item("Obj Import Util")