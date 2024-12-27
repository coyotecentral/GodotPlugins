extends Resource
class_name Generator

static func _generate(fname: String) -> void:
	print(fname)

	var scene = PackedScene.new()
	var root = Node3D.new()
	scene.pack(root)

static func generate(opts: Dictionary) -> void:
	pass