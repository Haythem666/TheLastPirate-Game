extends CharacterBody2D

@export var speed: float = 150.0
@export var acceleration: float = 5.0

# Float
@export var float_amplitude: float = 5.0  
@export var float_speed: float = 2.0      
var base_y: float = 0.0                  
var float_timer: float = 0.0              


var is_player_near: bool = false
var is_player_on_board: bool = false
var player: Player = null

# Nodes
@onready var ship_sprite: Sprite2D = $Sprite2D
@onready var sail_sprite: Sprite2D = $SailSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interaction_area: Area2D = $InteractionArea

func _ready():
	base_y = position.y
	
	interaction_area.area_entered.connect(_on_interaction_area_area_entered)
	interaction_area.area_exited.connect(_on_interaction_area_area_exited)
	
	animation_player.play("idle")

func _process(delta: float):
	
	if is_player_near and Input.is_action_just_pressed("attack"):
		if not is_player_on_board:
			board_ship()
		else:
			leave_ship()
	
	if is_player_on_board:
		control_ship(delta)
		
	float_timer += delta * float_speed
	position.y = base_y + sin(float_timer) * float_amplitude



func _on_interaction_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		is_player_near = true
		player = area.get_parent()
		


func _on_interaction_area_area_exited(area: Area2D) -> void:
	if area.get_parent() is Player:
		is_player_near = false
		if not is_player_on_board:
			player = null


func board_ship():
	if not player:
		return
	
	is_player_on_board = true
	
	player.set_physics_process(false)
	player.visible = false
	
	player.global_position = global_position
	

func leave_ship():
	if not player:
		return
	
	is_player_on_board = false
	
	player.set_physics_process(true)
	player.visible = true
	
	player.global_position = global_position + Vector2(80, 0)
	
	velocity = Vector2.ZERO
	animation_player.play("idle")
	

func control_ship(delta: float):
	var input_direction = Input.get_axis("left", "right")
	
	if input_direction != 0:
		# Accélérer
		velocity.x = lerp(velocity.x, input_direction * speed, acceleration * delta)
		
		# Orienter le bateau
		if input_direction > 0:
			ship_sprite.scale.x = abs(ship_sprite.scale.x)
			sail_sprite.scale.x = abs(sail_sprite.scale.x)
		else:
			ship_sprite.scale.x = -abs(ship_sprite.scale.x)
			sail_sprite.scale.x = -abs(sail_sprite.scale.x)
		
		if animation_player.current_animation != "sailing":
			animation_player.play("sailing")
	else:
		velocity.x = lerp(velocity.x, 0.0, acceleration * delta)
		
		if abs(velocity.x) < 10:
			velocity.x = 0
			if animation_player.current_animation != "idle":
				animation_player.play("idle")
	
	move_and_slide()	

	if player:
		player.global_position = global_position
