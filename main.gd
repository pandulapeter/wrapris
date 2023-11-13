extends Node

enum TestSceneId {
	BLOCK_PLACEMENT,
	BLOCK_MOVEMENT,
	SHAPE_MOVEMENT,
	SHAPE_COLORING
}

func _ready():
	$TestScenesMenuButton.get_popup().add_item("Block placement", TestSceneId.BLOCK_PLACEMENT)
	$TestScenesMenuButton.get_popup().add_item("Block movement", TestSceneId.BLOCK_MOVEMENT)
	$TestScenesMenuButton.get_popup().add_item("Shape movement", TestSceneId.SHAPE_MOVEMENT)
	$TestScenesMenuButton.get_popup().add_item("Shape coloring", TestSceneId.SHAPE_COLORING)
	$TestScenesMenuButton.get_popup().id_pressed.connect(onTestSceneSelected)

func onTestSceneSelected(sceneId: TestSceneId):
	match sceneId:
		TestSceneId.BLOCK_PLACEMENT:
			get_tree().change_scene_to_file("res://block/block_placement_test.tscn")
		TestSceneId.BLOCK_MOVEMENT:
			get_tree().change_scene_to_file("res://block/block_movement_test.tscn")
		TestSceneId.SHAPE_MOVEMENT:
			get_tree().change_scene_to_file("res://shapes/shape_movement_test.tscn")
		TestSceneId.SHAPE_COLORING:
			get_tree().change_scene_to_file("res://shapes/shape_coloring_test.tscn")
