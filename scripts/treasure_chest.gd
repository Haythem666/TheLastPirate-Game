extends StaticBody2D

var is_locked: bool = true
var is_open: bool = false
var player_nearby: bool = false
var nearby_player: Player = null

# Nodes
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interaction_area: Area2D = $InteractionArea
@onready var key_indicator: Sprite2D = $KeyIndicator
@onready var prompt_label: Label = $PromptLabel  


func _ready():
	interaction_area.area_entered.connect(_on_interaction_area_area_entered)
	interaction_area.area_exited.connect(_on_interaction_area_area_exited)
	
	animation_player.play("idle_locked")
	
	if prompt_label:
		prompt_label.visible = false

func _process(delta: float):
	update_prompt()
	
	if player_nearby and Input.is_action_just_pressed("attack"):
		attempt_open()



func update_prompt():
	if not player_nearby or is_open:
		if prompt_label:
			prompt_label.visible = false
		return
	
	if not prompt_label:
		return
	
	prompt_label.visible = true
	
	if is_locked:
		if nearby_player and GameManager.has_chest_key:
			prompt_label.text = "🗝️ [A] Open the Chest"
			prompt_label.modulate = Color.GREEN
		else:
			prompt_label.text = "🔒 Chest locked"
			prompt_label.modulate = Color.RED
	else:
		prompt_label.text = "[A] Open"
		prompt_label.modulate = Color.WHITE

func attempt_open():
	if is_open:
		return
	
	if is_locked:
		if nearby_player and GameManager.has_chest_key:
			unlock_chest()
		else:
			show_locked_message()
			shake_chest()
	else:
		open_chest()

func unlock_chest():
	is_locked = false
	
	if nearby_player:
		GameManager.has_chest_key = false
	
	animation_player.play("unlock")
	
	show_unlock_message()
	
	await animation_player.animation_finished
	
	open_chest()

func open_chest():
	if is_open:
		return
	
	is_open = true
	
	animation_player.play("open")
	
	await animation_player.animation_finished
	give_rewards()

func give_rewards():
	
	var reward_spawner = load("res://scripts/reward_spawner.gd")
	var spawn_pos = global_position + Vector2(0, -20)

	reward_spawner.spawn_mixed_rewards(spawn_pos, 8, 3, get_tree().root)
	
	await get_tree().create_timer(0.3).timeout
	
	show_reward_message("Chest Found!")


func show_locked_message():
	var label = create_floating_label("🔒 Chest locked!", Color.RED)
	animate_floating_label(label)

func show_unlock_message():
	var label = create_floating_label("🗝️ Chest unlocked", Color.GREEN)
	animate_floating_label(label)

func show_reward_message(text: String):
	var label = create_floating_label(text, Color.YELLOW)
	animate_floating_label(label)

func create_floating_label(text: String, color: Color) -> Label:
	var label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 18)
	label.modulate = color
	label.global_position = global_position - Vector2(40, 60)
	get_tree().root.add_child(label)
	return label

func animate_floating_label(label: Label):
	var tween = create_tween()
	tween.tween_property(label, "position:y", label.position.y - 40, 1.5)
	tween.parallel().tween_property(label, "modulate:a", 0.0, 1.5)
	await tween.finished
	label.queue_free()


func shake_chest():
	var original_pos = position
	var tween = create_tween()
	tween.tween_property(self, "position:x", original_pos.x + 3, 0.05)
	tween.tween_property(self, "position:x", original_pos.x - 3, 0.05)
	tween.tween_property(self, "position:x", original_pos.x + 3, 0.05)
	tween.tween_property(self, "position:x", original_pos.x, 0.05)


func _on_interaction_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		player_nearby = true
		nearby_player = area.get_parent()



func _on_interaction_area_area_exited(area: Area2D) -> void:
	if area.get_parent() is Player:
		player_nearby = false
		nearby_player = null
		if prompt_label:
			prompt_label.visible = false
