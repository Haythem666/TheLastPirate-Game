extends Node2D

@export var state := "0"
@export var sliding_platform_path: NodePath = "../Yplateform2"

var sliding_platform_node: Node = null
var bodies_on_button := []

func _ready():
	sliding_platform_node = get_node(sliding_platform_path)
	$Area2D.body_entered.connect(_on_area_2d_body_entered)
	$Area2D.body_exited.connect(_on_area_2d_body_exited)
	_update_button_appearance()
	

func _toggle_button():
	state = "1" if state == "0" else "0"
	_update_button_appearance()
	_play_platform_anim()


func _update_button_appearance():
	$NotPressedSprite.visible = state == "0"
	$PressedSprite.visible = state == "1"


func _play_platform_anim():
	if sliding_platform_node and sliding_platform_node.has_node("AnimationPlayer"):
		var anim_player = sliding_platform_node.get_node("AnimationPlayer")
		anim_player.play("downPlateform" if state == "1" else "upPlateform")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if  body.name == "PlayerTest" or body.name == "Box":
		print(body)
		bodies_on_button.append(body)
		if state == "0":
			_toggle_button()
			

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body in bodies_on_button:
		bodies_on_button.erase(body)
		if state == "1" and bodies_on_button.size()==0:
			_toggle_button()
