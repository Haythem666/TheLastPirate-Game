extends HBoxContainer

var heart_full = preload("res://assets/sprites/Objects/heartIdle.png")

var heart_textures: Array[TextureRect] = []

func _ready() -> void:
	#Wait till the player is ready
	await get_tree().process_frame
	if GameManager.player:
		update_hearts(GameManager.player.health, GameManager.player.max_health)

func update_hearts(current_health: int, max_health: int) -> void:
	
	if heart_textures.size() != max_health:
		_create_hearts(max_health)
	
	# Update the hearts
	for i in range(heart_textures.size()):
		if i < current_health:
			heart_textures[i].texture = heart_full
			heart_textures[i].modulate = Color(1, 1, 1, 1) 
		else:
			heart_textures[i].texture = heart_full
			heart_textures[i].modulate = Color(0.3, 0.3, 0.3, 0.5) #gris

func _create_hearts(count: int) -> void:
	for heart in heart_textures:
		heart.queue_free()
	heart_textures.clear()
	
	for i in range(count):
		var heart = TextureRect.new()
		heart.texture = heart_full
		heart.custom_minimum_size = Vector2(32, 32)
		heart.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		add_child(heart)
		heart_textures.append(heart)
