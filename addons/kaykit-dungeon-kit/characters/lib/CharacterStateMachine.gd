@tool
extends StateMachine
class_name CharacterStateMachine

@export var debug: bool = false
@export var animation_tree: AnimationTree

@export var movement_controller: MovementController :
	set(v):
		movement_controller = v
		for child in get_children():
			if child is CharacterState:
				_set_child_movement_controller(child, v)
	get:
		return movement_controller

@export var playback_parameter_path: String = "parameters/playback" :
	set(v):
		playback_parameter_path = v
		for c in get_children():
			if animation_tree and c is CharacterState:
				c._anim_state_machine = animation_tree.get(v)
	get:
		return playback_parameter_path

func init(p) -> void:
	_init_common()
	super(p)
	for child in get_children():
		child.init()

func change_state(next_state: State) -> void:
	if debug:
		print("Changing state to: %s" % next_state._animation_name)
	super(next_state)

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

func _set_child_movement_controller(c: CharacterState, controller: MovementController):
	c.movement_controller = controller

# TODO: this is double-assigning animation_tree
func _setup_child(c: CharacterState):
	if movement_controller:
		c.movement_controller = movement_controller
	if animation_tree:
		c._anim_state_machine = animation_tree.get(playback_parameter_path)