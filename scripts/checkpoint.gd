extends Node2D
class_name Checkpoint


@export var spawnpoint = false
var activated = false

func _ready() -> void:
	var start_y = $Sprite2D.position.y + 40
	var end_y = $Sprite2D.position.y
	$Sprite2D.position.y = start_y

	var tween = create_tween()
	tween.tween_property($Sprite2D, "position:y", end_y, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	if spawnpoint:
		activate()

func activate():
	GameManager.current_checkpoint = self
	activated = true
	$AnimationPlayer.play("activated")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player && !activated:
		activate()
