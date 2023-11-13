extends Node

var blockMovementSpeed = 0.1
var shapeCount = 0

func _unhandled_input(event):
		if event.is_action_pressed("ui_exit"):
			get_tree().quit()

func navigateToMainScreen():
	shapeCount = 0
	get_tree().change_scene_to_file("res://main.tscn")

func onNewShapeCreated():
	shapeCount += 1
	return shapeCount - 1
