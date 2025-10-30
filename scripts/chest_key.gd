extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collection_area: Area2D = $CollectionArea


func _ready():
	animation_player.play("idle")
	
	collection_area.area_entered.connect(_on_collection_area_area_entered)
	
	
	modulate.a = 0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5)



func collect_key(player: Player):
	
	GameManager.has_chest_key = true
	
	animation_player.play("collect")

	show_collection_message()
	
	# Disappearance animation
	var tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 0.0, 0.3)
	tween.parallel().tween_property(sprite, "scale", Vector2(1.5, 1.5), 0.3)

	
	await tween.finished
	queue_free()

func show_collection_message():
	var label = Label.new()
	label.text = "🗝️ Key collected!"
	label.add_theme_font_size_override("font_size", 20)
	label.modulate = Color.YELLOW
	
	label.global_position = global_position - Vector2(60, 40)
	get_tree().current_scene.add_child(label)


	var tween = create_tween()
	tween.tween_property(label, "position:y", label.position.y - 30, 1.0)
	tween.parallel().tween_property(label, "modulate:a", 0.0, 1.0)

	
	await tween.finished
	label.queue_free()


func _on_collection_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		collect_key(area.get_parent())
