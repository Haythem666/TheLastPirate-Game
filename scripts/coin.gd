extends Node2D

func _ready() -> void:
	$AnimationPlayer.play("idle")


func _on_area_2d_area_entered(area: Area2D) -> void:
	GameManager.gain_coins(1)
	queue_free()
	
