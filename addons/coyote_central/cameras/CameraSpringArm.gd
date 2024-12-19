@tool
extends SpringArm3D

var default_angle_deg: float = -20


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		for c in get_children():
			c.position.z = spring_length