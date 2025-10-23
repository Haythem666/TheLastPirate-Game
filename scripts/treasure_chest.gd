extends StaticBody2D

# État du coffre
var is_locked: bool = true
var is_open: bool = false
var player_nearby: bool = false
var nearby_player: Player = null

# Nodes
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interaction_area: Area2D = $InteractionArea
@onready var key_indicator: Sprite2D = $KeyIndicator
@onready var prompt_label: Label = $PromptLabel  # À créer

# Son d'ouverture (optionnel)
#var open_sound: AudioStreamPlayer2D

func _ready():
	# Connecter les signaux
	interaction_area.area_entered.connect(_on_interaction_area_area_entered)
	interaction_area.area_exited.connect(_on_interaction_area_area_exited)
	
	# État initial : fermé et verrouillé
	animation_player.play("idle_locked")
	
	# Indicateur de cadenas visible
	#if key_indicator:
		#key_indicator.texture = load("res://assets/sprites/Objects/Chest/Padlock/1.png")
		#key_indicator.visible = true
		#
		## Animation de bobbing pour le cadenas
		#animate_lock_indicator()
	#
	# Cacher le prompt
	if prompt_label:
		prompt_label.visible = false

func _process(delta: float):
	# Afficher/cacher le prompt selon la situation
	update_prompt()
	
	# Tenter d'ouvrir le coffre
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
		if nearby_player and nearby_player.has_chest_key:
			prompt_label.text = "🗝️ [E] Ouvrir le coffre"
			prompt_label.modulate = Color.GREEN
		else:
			prompt_label.text = "🔒 Coffre verrouillé"
			prompt_label.modulate = Color.RED
	else:
		prompt_label.text = "[E] Ouvrir"
		prompt_label.modulate = Color.WHITE

func attempt_open():
	if is_open:
		return
	
	# Si verrouillé, vérifier la clé
	if is_locked:
		if nearby_player and nearby_player.has_chest_key:
			unlock_chest()
		else:
			show_locked_message()
			shake_chest()
	else:
		open_chest()

func unlock_chest():
	is_locked = false
	
	# Consommer la clé
	if nearby_player:
		nearby_player.has_chest_key = false
	
	# Animation de déverrouillage
	animation_player.play("unlock")
	
	# Faire disparaître le cadenas
	#if key_indicator:
		#var tween = create_tween()
		#tween.tween_property(key_indicator, "modulate:a", 0.0, 0.5)
		#tween.tween_callback(func(): key_indicator.visible = false)
	
	# Son de déverrouillage
	#play_unlock_sound()
	
	# Message
	show_unlock_message()
	
	# Attendre la fin de l'animation
	await animation_player.animation_finished
	
	# Ouvrir automatiquement
	open_chest()

func open_chest():
	if is_open:
		return
	
	is_open = true
	
	# Animation d'ouverture
	animation_player.play("open")
	
	# Son d'ouverture
	#if open_sound:
	#	open_sound.play()
	
	# Récompense
	await animation_player.animation_finished
	give_rewards()

func give_rewards():
	
	# Spawner les récompenses visuelles
	var reward_spawner = load("res://scripts/reward_spawner.gd")
	# Position au-dessus du coffre
	var spawn_pos = global_position + Vector2(0, -20)

	# 8 pièces normales + 2 diamants
	reward_spawner.spawn_mixed_rewards(spawn_pos, 8, 2, get_tree().root)
	
	# Attendre un peu pour l'effet
	await get_tree().create_timer(0.3).timeout
	
	# Message
	show_reward_message("Trésor trouvé!")


func show_locked_message():
	var label = create_floating_label("🔒 Coffre verrouillé!", Color.RED)
	animate_floating_label(label)

func show_unlock_message():
	var label = create_floating_label("🗝️ Coffre déverrouillé!", Color.GREEN)
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

#func animate_lock_indicator():
	#if not key_indicator:
		#return
	#
	#var tween = create_tween()
	#tween.set_loops()
	#tween.tween_property(key_indicator, "position:y", key_indicator.position.y - 3, 0.5)
	#tween.tween_property(key_indicator, "position:y", key_indicator.position.y, 0.5)

#func play_unlock_sound():
	## Créer un AudioStreamPlayer temporaire
	#var sound = AudioStreamPlayer2D.new()
	#sound.stream = load("res://assets/sounds/unlock_sound.wav")  # À ajouter
	#add_child(sound)
	#sound.play()
	#await sound.finished
	#sound.queue_free()


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
