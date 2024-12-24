@tool
extends Control


var _items = []
# [path]: Control
var _instances: Dictionary = {}
var s_export_preview_item = preload("res://addons/dnguyen_tools/ui/main/ExportPreviewItem.tscn")

@onready var selected_items_vbox: VBoxContainer = $Panel/ScrollContainer/VBoxContainer

func _ready() -> void:
	_render()

func _process(delta: float) -> void:
	pass

func _render() -> void:
	if _items.size() > 0:
		$Panel/Empty.visible = false
	else:
		# TODO:
		# Position the file explorer somewhere that's not insane
		$Panel/Empty.visible = true

	# TODO:
	# make these loops non-blocking, or optimize
	for i in _items:
		if not _instances.has(i):
			var instance = s_export_preview_item.instantiate()
			instance.file_path = i
			instance.removed.connect(func():
				remove_selection(i)
			)
			# TODO: add a spinner for this
			selected_items_vbox.call_deferred("add_child", instance)
			_instances[i] = instance

	for key in _instances.keys():
		if not _items.has(key):
			_instances[key].queue_free()
			_instances.erase(key)
	
# Add a selection and remove any duplicates
func add_selection(array: PackedStringArray) -> void:
	for i in array:
		if not _items.has(i):
			_items.append(i)
	_render()

func remove_selection(path: String) -> void:
	_items.erase(path)
	_render()