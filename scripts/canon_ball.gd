extends Node2D

var direction 
var speed = 200.0
var lifetime = 2.0
var hit = false 


func _ready() -> void:
	await get_tree().create_timer(lifetime).timeout
	die()
	
	
func _physics_process(delta: float) -> void:
	position.x += abs(speed * delta) * direction
func die():
	hit = true
	speed = 0 
	$AnimationPlayer.play("hit")


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player && !hit:
		area.get_parent().take_damage(1)
		die()
