extends Node2D

@export var force=-700.0
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		area.get_parent().velocity.y = force
		if sprite_2d:
			$JumpSound.play()
			sprite_2d.play("jumppad")
