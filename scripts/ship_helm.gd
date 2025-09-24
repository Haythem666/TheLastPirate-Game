extends Node2D

@export var platform_path: NodePath = "../yPlateform"  
var platform: Node = null
var platform_anim: AnimationPlayer = null
var activated := false  

func _ready():
	platform = get_node(platform_path)
	if platform and platform.has_node("AnimationPlayer"):
		platform_anim = platform.get_node("AnimationPlayer")

func _process(delta):
	if not activated and $HelmArea.overlaps_body($"../PlayerTest") and Input.is_action_just_pressed("attack"):
		activate_helm()

func activate_helm():
	activated = true
	
	$AnimationPlayer.play("activateHelm")
	
	if platform_anim:
		platform_anim.play("down")
