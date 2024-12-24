@tool
extends VBoxContainer

func render(dict: Dictionary) -> void:
	$Tree.clear()
	_render_filesystem(dict, $Tree.create_item())
	var root = $Tree.get_root()
	root.set_text(0, "res://")
	root.set_icon(0, EditorInterface.get_editor_theme().get_icon("Folder", "EditorIcons"))
	root.set_selectable(0, false)

func _render_filesystem(dict: Dictionary, tree_item: TreeItem = null, url_segments: PackedStringArray = []):
	for d in dict["dirs"].keys():
		var c = $Tree.create_item(tree_item)
		c.set_text(0, d)
		c.set_icon(0, EditorInterface.get_editor_theme().get_icon("Folder", "EditorIcons"))
		c.set_selectable(0, false)
		var new_url_segments = url_segments.duplicate()
		new_url_segments.append(d)
		_render_filesystem(dict["dirs"][d], c, new_url_segments)
	for f in dict["files"]:
		var c = $Tree.create_item(tree_item)
		c.set_text(0, f)
		c.set_icon(0, EditorInterface.get_editor_theme().get_icon("Mesh", "EditorIcons"))
		var meta = "res://"
		for p in url_segments:
			meta += p + "/"
		meta += f
		c.set_metadata(0, meta)