extends CharacterBody2D

@export var friction: float = 800.0  # force qui ralentit la boîte
@export var push_strength: float = 300.0  # puissance avec laquelle le joueur peut pousser

func _physics_process(delta: float) -> void:
	# Appliquer frottement pour arrêter la boîte progressivement
	if velocity.x > 0:
		velocity.x = max(0, velocity.x - friction * delta)
	elif velocity.x < 0:
		velocity.x = min(0, velocity.x + friction * delta)

	move_and_slide()
