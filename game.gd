extends Node2D

var spawnX = 0
var shapes = [
	preload("res://shapes/shape01/shape_01.tscn"),
	preload("res://shapes/shape02/shape_02.tscn"),
	preload("res://shapes/shape03/shape_03.tscn"),
	preload("res://shapes/shape04/shape_04.tscn")
]

func _ready():
	spawnX = get_viewport().size.x / 2
	createRandomShape()

func createRandomShape():
	var shape : BaseShape = shapes[randi() % shapes.size()].instantiate()
	shape.global_position = Vector2(spawnX, 0)
	shape.movement_stopped.connect(createRandomShape)
	add_child(shape)
