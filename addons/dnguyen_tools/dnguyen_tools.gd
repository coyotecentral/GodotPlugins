@tool
extends EditorPlugin

const MainPanel = preload("res://addons/dnguyen_tools/ui/main/main.tscn")

var i_main_panel: Control

func _enter_tree() -> void:
	i_main_panel = MainPanel.instantiate()
	EditorInterface.get_editor_main_screen().add_child(i_main_panel)
	_make_visible(false)

func _exit_tree() -> void:
	if i_main_panel:
		i_main_panel.queue_free()

func _has_main_screen() -> bool:
	return true

func _make_visible(visible: bool) -> void:
	if i_main_panel:
		i_main_panel.visible = visible

func _get_plugin_name() -> String:
	return "Tools"

func _get_plugin_icon():
	return EditorInterface.get_editor_theme().get_icon("Node", "EditorIcons")