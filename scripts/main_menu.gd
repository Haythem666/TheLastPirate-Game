extends Control


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass



func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/pirate_cabin.tscn")
	

func _on_settings_pressed() -> void:
	pass 

func _on_exit_pressed() -> void:
	get_tree().quit()
