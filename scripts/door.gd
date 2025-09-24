extends Node2D

@export var next_scene: PackedScene   # à remplir dans Level1, vide dans Level2
@export var is_exit: bool = false     # coche dans Level2 pour la porte d’arrivée

var opening = false

func _ready():
	if is_exit:
		# Si c’est une porte d’arrivée → elle se ferme toute seule
		$AnimationPlayer.play("closing")
	else:
		# Sinon → état fermé par défaut
		$AnimationPlayer.play("closing")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not is_exit and not opening:
		opening = true
		$AnimationPlayer.play("opening")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "opening" and opening and not is_exit:
		get_tree().change_scene_to_packed(next_scene)
