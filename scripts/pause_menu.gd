extends CanvasLayer

@onready var resume_button: Button = $VBoxContainer/resume_button
#@onready var quit_button: Button = $VBoxContainer/quit_button


func _ready() -> void:
	# Au départ, on cache le menu
	visible = false
	
	# Connecte les boutons
	resume_button.pressed.connect(_on_resume_pressed)
	#quit_button.pressed.connect(_on_quit_pressed)

func _input(event: InputEvent) -> void:
	# Exemple : touche "Escape" (tu peux configurer une InputMap appelée "pause")
	if event.is_action_pressed("pause"):
		toggle_pause()

func toggle_pause() -> void:
	if get_tree().paused:
		# Reprendre la partie
		get_tree().paused = false
		visible = false
	else:
		# Mettre en pause
		get_tree().paused = true
		visible = true

func _on_resume_pressed() -> void:
	# Quand on clique sur Resume
	get_tree().paused = false
	visible = false

func _on_quit_pressed() -> void:
	# Pour l'instant juste quitter le jeu (tu peux changer plus tard)
	get_tree().quit()
