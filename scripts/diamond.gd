extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collection_area: Area2D = $Area2D
@onready var collection_timer: Timer = Timer.new()

var can_collect: bool = false
var coin_value: int = 1
var is_reward: bool = false  

func _ready():
	add_child(collection_timer)
	collection_timer.one_shot = true
	collection_timer.timeout.connect(_enable_collection)
	
	if animation_player:
		animation_player.play("idle")
	
	if is_reward:
		collection_area.monitoring = false
		collection_timer.start(0.5)
	else:
		
		can_collect = true

func setup_as_reward(spawn_position: Vector2, launch_direction: Vector2, value: int = 1):
	is_reward = true
	global_position = spawn_position
	coin_value = value
	

func _enable_collection():
	can_collect = true
	collection_area.monitoring = true

func _on_area_2d_area_entered(area: Area2D):
	if not can_collect:
		return
	
	if area.get_parent().name == "PlayerTest":
		collect()

func collect():
	
	GameManager.gain_coins(coin_value)
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(sprite, "scale", Vector2(1.5, 1.5), 0.2)
	tween.tween_property(sprite, "modulate:a", 0.0, 0.2)

	await tween.finished
	
	queue_free()
