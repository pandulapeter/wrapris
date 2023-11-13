extends MenuButton

enum TestMenuItemId {
	RESET,
	LEAVE
}

func _ready():
	get_popup().add_item("Reset", TestMenuItemId.RESET)
	get_popup().add_item("Leave", TestMenuItemId.LEAVE)
	get_popup().id_pressed.connect(onTestMenuItemSelected)

func onTestMenuItemSelected(menuItemId: TestMenuItemId):
	match menuItemId:
		TestMenuItemId.RESET:
			get_tree().reload_current_scene()
		TestMenuItemId.LEAVE:
			get_tree().change_scene_to_file("res://main.tscn")
