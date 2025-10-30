extends Node2D

@export var swing_angle: float = 60.0    
@export var swing_speed: float = 1.5     

# Nodes
@onready var pivot: Node2D = $Pivot
@onready var chain_container: Node2D = $Pivot/ChainContainer
@onready var spike_ball: Area2D = $Pivot/SpikeBall

# Movement variables
var time: float = 0.0
var initial_offset: float = 0.0  

func _ready():
	
	if spike_ball:
		spike_ball.area_entered.connect(_on_spike_ball_area_entered)
	
	# Random offset so that each pendulum is different
	initial_offset = randf() * TAU  # TAU = 2*PI

func _process(delta: float):
	time += delta
	
	var angle = deg_to_rad(swing_angle) * sin((time + initial_offset) * swing_speed)
	
	pivot.rotation = angle


func _on_spike_ball_area_entered(area: Area2D):
	if area.get_parent() is Player:
		area.get_parent().take_damage(1)
