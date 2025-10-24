extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collection_area: Area2D = $Area2D
@onready var pickup_sound: AudioStreamPlayer2D = $PickUpSound
@onready var collection_timer: Timer = Timer.new()

var can_collect: bool = false
var coin_value: int = 1
var is_reward: bool = false  # Pour différencier pièce statique vs récompense

func _ready():
	# Ajouter le timer
	add_child(collection_timer)
	collection_timer.one_shot = true
	collection_timer.timeout.connect(_enable_collection)
	
	# Animation idle
	if animation_player:
		animation_player.play("idle")
	
	# Si c'est une récompense physique, attendre avant de pouvoir collecter
	if is_reward:
		collection_area.monitoring = false
		collection_timer.start(0.5)
	else:
		# Pièce statique normale - collection immédiate
		#freeze = true  # Figer la physique
		can_collect = true

func setup_as_reward(spawn_position: Vector2, launch_direction: Vector2, value: int = 1):
	"""Configure la pièce comme récompense avec physique"""
	is_reward = true
	global_position = spawn_position
	coin_value = value
	

func _enable_collection():
	"""Active la possibilité de collecter après un délai"""
	can_collect = true
	collection_area.monitoring = true

func _on_area_2d_area_entered(area: Area2D):
	if not can_collect:
		return
	
	if area.get_parent().name == "PlayerTest":
		collect()

func collect():
	"""Collecter la pièce"""
	# Donner les pièces au joueur
	GameManager.gain_coins(coin_value)
	
	# Son
	if pickup_sound:
		pickup_sound.play()
	
	# Effet visuel
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(sprite, "scale", Vector2(1.5, 1.5), 0.2)
	tween.tween_property(sprite, "modulate:a", 0.0, 0.2)
	
	# Attendre la fin du son
	if pickup_sound and pickup_sound.playing:
		await pickup_sound.finished
	else:
		await tween.finished
	
	queue_free()
