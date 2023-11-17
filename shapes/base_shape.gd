extends Node2D

class_name BaseShape

signal movement_stopped
signal row_completed

const BUTTON_HOLD_LIMIT = 100
const COLORS = [
	Color.BLUE,
	Color.BLUE_VIOLET,
	Color.CHARTREUSE,
	Color.CRIMSON,
	Color.CYAN,
	Color.GOLD,
	Color.GREEN
]

@export var nextRotation: PackedScene
@export var moveTimerWaitTime: float = 0.5
@export var tint: Color = Color.BLACK
var lastMovementTimestamp = 0
var shapeId

var rotations = []
var rotationVariant = 0
var hasEmittedMovementStoppedSignal = false
var shouldRetryRotationInNextFrame = false
var lastCompletedRow = -1

var touch

func initialize(rotations):
	self.rotations = rotations
	if shapeId == null:
		shapeId = "shape" + str($"/root/Shared".onNewShapeCreated())
	if tint == Color.BLACK:
		tint = generateRandomColor()
	for block in get_children():
		block.tint = tint
		block.moveTimerWaitTime = moveTimerWaitTime
		block.initializeInheritedState(shapeId)
		block.movement_stopped.connect(onMovementStopped)
		block.row_completed.connect(onRowCompleted)
	if (rotations.size() > 0):
		for n in randi() % rotations.size():
			rotateShape()

func _process(delta):
	if canMove():
		if lastCompletedRow != -1:
			lastCompletedRow = -1
		if shouldRetryRotationInNextFrame:
			shouldRetryRotationInNextFrame = false
			rotateShape()
		if Input.is_action_just_pressed("shape_rotate"):
			rotateShape()
		var movementDirection = Vector2.ZERO
		if Input.is_action_pressed("shape_move_left"):
			movementDirection += Vector2.LEFT
		if Input.is_action_pressed("shape_move_right"):
			movementDirection += Vector2.RIGHT
		if Input.is_action_pressed("shape_move_down"):
			movementDirection += Vector2.DOWN
		if movementDirection != Vector2.ZERO:
			var currentTime = Time.get_ticks_msec()
			if currentTime - lastMovementTimestamp > BUTTON_HOLD_LIMIT:
				lastMovementTimestamp = currentTime
				for block in getChildBlocks():
					block.move(movementDirection)

func _unhandled_input(event):
	if event is InputEventScreenTouch && event.index == 0:
		if event.is_pressed():
			touch = event.position
		if event.is_released():
			var position = event.position
			if touch != null && touch != position:
				var movementDirection = (position - touch).normalized()
				var distanceToLeft = movementDirection.distance_to(Vector2.LEFT)
				var distanceToUp = movementDirection.distance_to(Vector2.UP)
				var distanceToRight = movementDirection.distance_to(Vector2.RIGHT)
				var distanceToDown = movementDirection.distance_to(Vector2.DOWN)
				match [distanceToLeft, distanceToUp, distanceToRight, distanceToDown].min():
					distanceToLeft:
						for block in getChildBlocks():
							block.move(Vector2.LEFT)
						print("Left detected")
					distanceToUp:
						rotateShape()
						print("Up detected")
					distanceToRight:
						for block in getChildBlocks():
							block.move(Vector2.RIGHT)
						print("Right detected")
					distanceToDown:
						for block in getChildBlocks():
							block.move(Vector2.DOWN)
						print("Down detected")
			touch = null

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

func rotateShape():
	if rotations.size() > 0:
		var canRotate = true
		var index = 0
		for block in getChildBlocks():
			if not block.canMoveToDirection(rotations[rotationVariant][index]):
				canRotate = false
				break
			if block.isSettling:
				shouldRetryRotationInNextFrame = true
				canRotate = false
			index += 1
		if canRotate:
			index = 0
			for block in getChildBlocks():
				block.normalizedDestinationInNextFrame += rotations[rotationVariant][index]
				block.animateRotation()
				index += 1
			rotationVariant += 1
			rotationVariant = wrapi(rotationVariant, 0, rotations.size())
		return canRotate

func generateRandomColor():
	return COLORS[randi() % COLORS.size()]

func onMovementStopped():
	if !hasEmittedMovementStoppedSignal:
		movement_stopped.emit()
		hasEmittedMovementStoppedSignal = true

func onRowCompleted(index):
	if lastCompletedRow != index:
		lastCompletedRow = index
		row_completed.emit()
		for block in get_tree().get_nodes_in_group("blocks"):
			if block.normalizedDestinationInNextFrame.y <= index:
				block.normalizedDestinationInNextFrame += Vector2.DOWN
