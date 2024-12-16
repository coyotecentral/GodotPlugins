@tool
extends CoyoteCharacter3D
class_name Barbarian

var _scene: PackedScene = preload("res://addons/coyote_central/characters/barbarian/barbarian.tscn")

@export var stats: CharacterStats
var state_machine: StateMachine



# Called when the node enters the scene tree for the first time.
func _ready():
	var scene = _scene.instantiate()
	add_child(scene)
	state_machine = scene.get_node("CharacterStateMachine")
	state_machine.init(self)


func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		state_machine.process_frame(delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		state_machine.process_physics(delta)

func _input(event: InputEvent) -> void:
	if not Engine.is_editor_hint():
		state_machine.process_input(event)