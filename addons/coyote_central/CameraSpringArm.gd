@tool
extends SpringArm3D

var default_angle_deg: float = -20


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var child = get_child(0)
	child.position.z = spring_length
