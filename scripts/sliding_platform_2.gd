extends AnimatableBody2D

@export var move_distance: float = 300.0   # distance de déplacement
@export var move_duration: float = 5.0     # durée pour faire un aller simple

func _ready():
	var start_pos = position
	var end_pos = start_pos + (Vector2.RIGHT * move_distance)

	var tween = create_tween()
	tween.set_loops() # répète infiniment
	
	tween.tween_property(self, "position", end_pos, move_duration)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", start_pos, move_duration)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
