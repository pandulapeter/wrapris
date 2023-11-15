extends Node2D

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

func _ready():
	spawnX = get_viewport().size.x / 2
	createRandomShape()

func createRandomShape():
	var shape : BaseShape = shapes[randi() % shapes.size()].instantiate()
	shape.global_position = Vector2(spawnX, -32)
	shape.movement_stopped.connect(createRandomShape)
	add_child(shape)
