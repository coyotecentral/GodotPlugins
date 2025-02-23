@tool
extends KayKitDungeonCharacter
class_name Knight

var _scene: PackedScene = preload("res://addons/kaykit-dungeon-kit/characters/knight/knight.tscn")

@export var stats: CharacterStats
var state_machine: StateMachine

# Called when the node enters the scene tree for the first time.
func _ready():
	var scene = _scene.instantiate()
	var _children = []
	if not Engine.is_editor_hint():
		for c in get_children():
			_children.push_back(c)
	if not Engine.is_editor_hint():
		for c in _children:
			c.reparent(scene)
	add_child(scene)
	scene.stats = stats
	state_machine = scene.get_node("MovementStateMachine")
	state_machine.init(scene)


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