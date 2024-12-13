@tool
extends StateMachine
class_name CharacterStateMachine

@export var debug: bool = false
@export var animations: AnimationPlayer :
	set(v):
		animations = v	
		_init_common()
	get:
		return animations


@export var movement_controller: MovementController

func init(p) -> void:
	_init_common()
	super(p)
	for child in get_children():
		child.init()

func _ready():
	child_entered_tree.connect(func(c):
		if c is CharacterState:
			_setup_child(c)
	)
	if Engine.is_editor_hint():
		_init_common()

# Initialization code that's common between the tool and the in-game
func _init_common():
	for child in get_children():
		_setup_child(child)

func _setup_child(c: CharacterState):
	if animations:
		c.animations = animations
	if movement_controller:
		c.movement_controller = movement_controller
	c.parent = parent
	c.init()