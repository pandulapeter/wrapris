extends Node

var blockMovementSpeed = 0.2
var shapeCount = 0

func _unhandled_input(event):
	if event.is_action_pressed("ui_exit"):
		if get_parent().get_child(1).get_name() == "Main":
			get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
			get_tree().quit()
		else:
			navigateToMainScreen()

func navigateToMainScreen():
	shapeCount = 0
	get_tree().change_scene_to_file("res://main.tscn")

func onNewShapeCreated():
	shapeCount += 1
	return shapeCount - 1
