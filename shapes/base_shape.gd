extends Node2D

class_name BaseShape

@export var shouldShowDebugInfo: bool = false
@export var moveTimerWaitTime: float = 0.5
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
	shapeId = "shape" + str($"/root/Shared".onNewShapeCreated())
	print("Shape " + shapeId + " child count: " + str(get_child_count()))
	var tint = generateRandomColor()
	for block in get_children():
		block.tint = tint
		block.shouldShowDebugInfo = shouldShowDebugInfo
		block.moveTimerWaitTime = moveTimerWaitTime
		block.initializeInheritedState(shapeId)

func _unhandled_input(event):
	if (event.is_action_pressed("shape_rotate") && canMove()):
		rotateShape()

func rotateShape():
	pass

func generateRandomColor():
	return possibleColors[randi() % possibleColors.size()]
