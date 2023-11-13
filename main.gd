extends Node

enum TestSceneId {
	BLOCK,
	SHAPES
}

func _ready():
	$TestScenesMenuButton.get_popup().add_item("Block", TestSceneId.BLOCK)
	$TestScenesMenuButton.get_popup().add_item("Shapes", TestSceneId.SHAPES)
	$TestScenesMenuButton.get_popup().id_pressed.connect(onTestSceneSelected)

func onTestSceneSelected(sceneId: TestSceneId):
	match sceneId:
		TestSceneId.BLOCK:
			get_tree().change_scene_to_file("res://block/block_test.tscn")
		TestSceneId.SHAPES:
			get_tree().change_scene_to_file("res://shapes/shape_test.tscn")
