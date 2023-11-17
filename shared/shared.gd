extends Node

var shapeCount = 0

func _ready():
	get_tree().set_auto_accept_quit(false)

func _unhandled_input(event):
	if event.is_action_pressed("ui_exit"):
		navigateBack()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		navigateBack()
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		navigateBack()

func navigateToMainScreen():
	shapeCount = 0
	get_tree().change_scene_to_file("res://main.tscn")

func onNewShapeCreated():
	shapeCount += 1
	return shapeCount - 1

func navigateBack():
	if get_parent().get_child(1).get_name() == "Main":
		get_tree().quit()
	else:
		navigateToMainScreen()
