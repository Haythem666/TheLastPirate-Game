extends CanvasLayer


@export var darkness_intensity: float = 0.85

@export var player_light_radius: float = 150.0

var player: Player = null
var ambient_darkness: ColorRect

func _ready():
	setup_ambient_darkness()
	
	await get_tree().process_frame
	
	
	player = GameManager.player
	
	if player:
		setup_player_light()
		
		
func setup_ambient_darkness():
	ambient_darkness = ColorRect.new()
	ambient_darkness.name = "AmbientDarkness"
	
	ambient_darkness.color = Color(0, 0, 0, darkness_intensity)
	
	ambient_darkness.set_anchors_preset(Control.PRESET_FULL_RECT)
	
	add_child(ambient_darkness)
	

func setup_player_light():
	var player_light = PointLight2D.new()
	player_light.name = "PlayerLight"
	
	player_light.enabled = true
	player_light.texture = create_radial_gradient()
	player_light.texture_scale = player_light_radius / 256.0
	player_light.color = Color(1.0, 0.9, 0.7, 1.0)  # light
	player_light.energy = 1.2  # intensity
	player_light.blend_mode = Light2D.BLEND_MODE_ADD 
	
	player.add_child(player_light)
	

func create_radial_gradient() -> GradientTexture2D:
	var gradient = Gradient.new()
	gradient.set_color(0, Color(1, 1, 1, 1))  #white center
	gradient.set_color(1, Color(0, 0, 0, 0))  #transparent edge
	
	var gradient_texture = GradientTexture2D.new()
	gradient_texture.gradient = gradient
	gradient_texture.fill = GradientTexture2D.FILL_RADIAL  
	gradient_texture.fill_from = Vector2(0.5, 0.5)  
	gradient_texture.fill_to = Vector2(1.0, 0.5)  
	gradient_texture.width = 512
	gradient_texture.height = 512
	
	return gradient_texture

func _process(delta: float):
	if player and player.has_node("PlayerLight"):
		var player_light = player.get_node("PlayerLight")
		
		var time = Time.get_ticks_msec() / 1000.0  
		var pulse = sin(time * 2.0) * 0.1  
		
		player_light.energy = 1.2 + pulse
