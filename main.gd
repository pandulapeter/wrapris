extends Node

func _on_new_game_button_pressed():
	get_tree().change_scene_to_file("res://shapes/shape_movement_test.tscn")
