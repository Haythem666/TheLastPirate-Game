extends Node2D

@export var state := "0"
@export var sliding_platform_path: NodePath = "../SlidingPlatform"

var sliding_platform_node: Node = null


func _ready():
	sliding_platform_node = get_node(sliding_platform_path)
	_update_lever_appearance()


func _process(delta):
	if $AreaLever.overlaps_body($"../PlayerTest") and Input.is_action_just_pressed("attack"):
		_toggle_lever()


func _toggle_lever():
	if state == "0":
		state = "1"
	else:
		state = "0"
	
	_update_lever_appearance()
	
	_play_platform_anim()


func _update_lever_appearance():
	if state == "0":
		$LeverLeft.flip_h = false
	else:
		$LeverLeft.flip_h = true

func _play_platform_anim():
	if sliding_platform_node and sliding_platform_node.has_node("AnimationPlayer"):
		var anim_player = sliding_platform_node.get_node("AnimationPlayer")
		if state == "1":
			anim_player.play("slidingRight")
		else:
			anim_player.play("slidindLeft")
