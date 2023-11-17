extends Node

var spawnX = 0
var shapes = [
	preload("res://shapes/shape01/shape_01.tscn"),
	preload("res://shapes/shape02/shape_02.tscn"),
	preload("res://shapes/shape03/shape_03.tscn"),
	preload("res://shapes/shape04/shape_04.tscn"),
	preload("res://shapes/shape05/shape_05.tscn"),
	preload("res://shapes/shape06/shape_06.tscn"),
	preload("res://shapes/shape07/shape_07.tscn")
]
var score = 0
var scoreLabelPosition: Vector2
var menuButtonPosition: Vector2

func _ready():
	spawnX = get_viewport().size.x / 2
	updateScoreLabel()
	createRandomShape()
	scoreLabelPosition = $ScoreLabel.global_position
	menuButtonPosition = $MenuButton.global_position
	resizeSafeArea()
	get_tree().get_root().size_changed.connect(resizeSafeArea)

func resizeSafeArea():
	var safeArea = DisplayServer.get_display_safe_area()
	$ScoreLabel.set_offsets_preset(
		Control.LayoutPreset.PRESET_TOP_LEFT,
		Control.LayoutPresetMode.PRESET_MODE_MINSIZE,
		safeArea.position.y
	)
	
	$MenuButton.set_offsets_preset(
		Control.LayoutPreset.PRESET_TOP_RIGHT,
		Control.LayoutPresetMode.PRESET_MODE_MINSIZE,
		safeArea.position.y
	)

func createRandomShape():
	var shape : BaseShape = shapes[randi() % shapes.size()].instantiate()
	shape.global_position = Vector2(spawnX, -32)
	shape.movement_stopped.connect(createRandomShape)
	shape.row_completed.connect(onRowCompleted)
	add_child(shape)

func onRowCompleted():
	score += 1
	updateScoreLabel()

func updateScoreLabel():
	$ScoreLabel.text = "Score: " + str(score)


func _on_menu_button_pressed():
	$"/root/Shared".navigateToMainScreen()
