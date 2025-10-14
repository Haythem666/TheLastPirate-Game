##RENDRE STATIC BODY 2D ET FAIRE AVEC ANIMATION PLAYER 



extends AnimatableBody2D

@export var move_distance: float = 200.0 # distance de déplacement
@export var move_speed: float = 100.0    # vitesse
@export var vertical: bool = false       # si true → bouge verticalement

var start_position: Vector2
var direction: int = 1

func _ready():
	start_position = position

func _physics_process(delta: float) -> void:
	var displacement = move_speed * direction * delta

	if vertical:
		position.y += displacement
		if abs(position.y - start_position.y) >= move_distance:
			# 🔧 Corrige le dépassement exact :
			position.y = start_position.y + direction * move_distance
			direction *= -1
	else:
		position.x += displacement
		if abs(position.x - start_position.x) >= move_distance:
			# 🔧 Corrige le dépassement exact :
			position.x = start_position.x + direction * move_distance
			direction *= -1
