extends AnimationTree

@onready var movement_playback = get("parameters/MovementStateMachine/playback")
@onready var attack_anim_node: AnimationNodeOneShot = tree_root.get_node("AttackOneShot")
@onready var parent: CharacterBody3D = get_parent()
var blend_path = "parameters/Blend2/blend_amount"
var attack_anim_request_path = "parameters/AttackOneShot/request"

func _ready() -> void:
	print(attack_anim_node)
	# print(oneshot_animation.is_path_filtered("Rig/Skeleton3D/elbowIK.l"))
	# attack_playback.travel("Start")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		if parent.velocity.length() == 0:
			attack_anim_node.filter_enabled = false
		else:
			attack_anim_node.filter_enabled = true
		set(attack_anim_request_path, AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)