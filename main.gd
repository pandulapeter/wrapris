extends Node

func _on_new_game_button_pressed():
	get_tree().change_scene_to_file("res://game.tscn")
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_enter"):
		_on_new_game_button_pressed()
