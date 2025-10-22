extends CanvasLayer

# === PARAMÈTRES RÉGLABLES ===
# Intensité de l'obscurité (0.0 = clair, 1.0 = noir total)
@export var darkness_intensity: float = 0.85

# Taille de la lumière autour du joueur
@export var player_light_radius: float = 150.0

# === VARIABLES INTERNES ===
var player: Player = null
var ambient_darkness: ColorRect

func _ready():
	# Étape 1 : Créer l'obscurité générale
	setup_ambient_darkness()
	
	# Étape 2 : Attendre que le joueur soit chargé
	await get_tree().process_frame
	
	# Étape 3 : Trouver le joueur dans la scène
	player = get_tree().get_first_node_in_group("player")
	if not player:
		player = GameManager.player
	
	# Étape 4 : Ajouter une lumière au joueur
	if player:
		setup_player_light()

# === FONCTION 1 : CRÉER LE VOILE NOIR ===
func setup_ambient_darkness():
	# Créer un rectangle qui couvre tout l'écran
	ambient_darkness = ColorRect.new()
	ambient_darkness.name = "AmbientDarkness"
	
	# Définir la couleur : noir avec transparence
	ambient_darkness.color = Color(0, 0, 0, darkness_intensity)
	
	# Faire en sorte qu'il remplisse tout l'écran
	ambient_darkness.set_anchors_preset(Control.PRESET_FULL_RECT)
	
	# L'ajouter à la scène
	add_child(ambient_darkness)
	
	print("✓ Obscurité créée avec intensité : ", darkness_intensity)

# === FONCTION 2 : CRÉER LA LUMIÈRE DU JOUEUR ===
func setup_player_light():
	# Créer une source de lumière
	var player_light = PointLight2D.new()
	player_light.name = "PlayerLight"
	
	# Configuration de la lumière
	player_light.enabled = true
	player_light.texture = create_radial_gradient()
	player_light.texture_scale = player_light_radius / 256.0
	player_light.color = Color(1.0, 0.9, 0.7, 1.0)  # Lumière chaude/dorée
	player_light.energy = 1.2  # Intensité
	player_light.blend_mode = Light2D.BLEND_MODE_ADD  # Mode de fusion
	
	# Attacher la lumière au joueur
	player.add_child(player_light)
	
	print("✓ Lumière du joueur créée")

# === FONCTION 3 : CRÉER LA TEXTURE DE LUMIÈRE ===
func create_radial_gradient() -> GradientTexture2D:
	# Créer un dégradé (du blanc au transparent)
	var gradient = Gradient.new()
	gradient.set_color(0, Color(1, 1, 1, 1))  # Centre : blanc opaque
	gradient.set_color(1, Color(0, 0, 0, 0))  # Bord : transparent
	
	# Créer une texture avec ce dégradé
	var gradient_texture = GradientTexture2D.new()
	gradient_texture.gradient = gradient
	gradient_texture.fill = GradientTexture2D.FILL_RADIAL  # Forme circulaire
	gradient_texture.fill_from = Vector2(0.5, 0.5)  # Centre
	gradient_texture.fill_to = Vector2(1.0, 0.5)  # Rayon
	gradient_texture.width = 512
	gradient_texture.height = 512
	
	return gradient_texture

# === FONCTION 4 : FAIRE PULSER LA LUMIÈRE ===
func _process(delta: float):
	# Trouver la lumière du joueur
	if player and player.has_node("PlayerLight"):
		var player_light = player.get_node("PlayerLight")
		
		# Calculer un effet de pulsation
		var time = Time.get_ticks_msec() / 1000.0  # Temps en secondes
		var pulse = sin(time * 2.0) * 0.1  # Oscillation entre -0.1 et +0.1
		
		# Appliquer l'effet
		player_light.energy = 1.2 + pulse
