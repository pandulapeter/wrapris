extends Node2D

class_name BaseShape

@export var tint: Color = Color.WHITE
@export var shouldShowDebugInfo: bool = false
var shapeId

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
	for block in get_children():
		block.tint = tint
		block.shouldShowDebugInfo = shouldShowDebugInfo
		block.initializeInheritedState(shapeId)

func _unhandled_input(event):
	if (event.is_action_pressed("shape_rotate") && canMove()):
		rotateShape()

func rotateShape():
	pass
