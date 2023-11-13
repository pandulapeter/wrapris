extends Node2D

class_name BaseShape

@export var nextRotation: PackedScene
@export var shouldShowDebugInfo: bool = false
@export var moveTimerWaitTime: float = 0.5
@export var tint: Color = Color.BLACK
var shapeId
var possibleColors = [
	Color.BLUE,
	Color.BLUE_VIOLET,
	Color.CHARTREUSE,
	Color.CRIMSON,
	Color.CYAN,
	Color.GOLD,
	Color.GREEN
]

func getChildBlocks():
	if (shapeId == null):
		return null
	var blocks = Array()
	for block in get_children():
		if (block.is_in_group(shapeId)):
			blocks.append(block)
	return blocks

func canMove():
	var canMove = true
	for block in getChildBlocks():
		if (!block.isMoving):
			canMove = false
	return canMove

func initialize():
	if shapeId == null:
		shapeId = "shape" + str($"/root/Shared".onNewShapeCreated())
		print("Shape " + shapeId + " child count: " + str(get_child_count()))
	if tint == Color.BLACK:
		tint = generateRandomColor()
	for block in get_children():
		block.tint = tint
		block.shouldShowDebugInfo = shouldShowDebugInfo
		block.moveTimerWaitTime = moveTimerWaitTime
		block.initializeInheritedState(shapeId)

func _process(delta):
	if canMove():
		if Input.is_action_just_pressed("shape_move_left"):
			for block in getChildBlocks():
				block.moveLeft()
		if Input.is_action_just_pressed("shape_move_right"):
			for block in getChildBlocks():
				block.moveRight()
		if Input.is_action_just_pressed("shape_move_down"):
			for block in getChildBlocks():
				block.moveDown()
		if Input.is_action_pressed("shape_rotate"):
			rotateShape()

func rotateShape():
	#var newNode: BaseShape = nextRotation.instantiate()
	#newNode.global_position = global_position
	#newNode.tint = tint
	#newNode.shapeId = shapeId
	#get_parent().add_child(newNode)
	#get_parent().remove_child(self)
	#queue_free()
	pass

func generateRandomColor():
	return possibleColors[randi() % possibleColors.size()]
