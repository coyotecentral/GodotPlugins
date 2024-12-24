@tool
extends EditorPlugin

const MainWindow = preload("res://addons/obj-import-util/ui/main/main_window.tscn")

var i_main_window: Window

func _enter_tree() -> void:
	add_tool_menu_item("Obj Import Util", func():
		if not i_main_window:
			i_main_window = MainWindow.instantiate()
			EditorInterface.get_base_control().add_child(i_main_window)

		# Encountered and errror where we would attempt to re-connect the same method
		if not i_main_window.close_requested.is_connected(i_main_window.hide):
			i_main_window.close_requested.connect(i_main_window.hide)
		if not i_main_window.close_requested.is_connected(_clear_selection):
			i_main_window.close_requested.connect(_clear_selection)

		i_main_window.show()
	)

func _exit_tree() -> void:
	if i_main_window:
		i_main_window.queue_free()
		remove_tool_menu_item("Obj Import Util")

func _clear_selection() -> void:
	if i_main_window:
		print("Clearing selection")
		i_main_window.get_node("Control").reset()