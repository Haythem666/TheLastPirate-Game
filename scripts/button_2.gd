extends Node2D

@export var state := "0"
@export var sliding_platform_path: NodePath = "../y_plateform"

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
	if not sliding_platform_node:
		return

	var tween = create_tween()
	var move_distance = 100.0  # distance verticale à bouger (modifie selon ton besoin)
	var duration = 1.0         # durée de l’animation (en secondes)

	# Position actuelle
	var start_pos = sliding_platform_node.position

	# Nouvelle position selon l’état
	var target_y = start_pos.y + move_distance if state == "1" else start_pos.y - move_distance

	tween.tween_property(sliding_platform_node, "position:y", target_y, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if  body.name == "PlayerTest" or body.name == "Box":
		bodies_on_button.append(body)
		if state == "0":
			_toggle_button()
	



func _on_area_2d_body_exited(body: Node2D) -> void:
	if body in bodies_on_button:
		bodies_on_button.erase(body)
		if state == "1" and bodies_on_button.size()==0:
			_toggle_button()
