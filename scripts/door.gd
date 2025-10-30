extends Node2D

@export var next_scene: PackedScene   

var opening = false

func _ready():
	$AnimationPlayer.play("closing")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not opening:
		opening = true
		$AnimationPlayer.play("opening")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "opening" and opening :
		get_tree().change_scene_to_packed(next_scene)
