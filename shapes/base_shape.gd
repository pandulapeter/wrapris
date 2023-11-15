extends Node2D

class_name BaseShape

signal movement_stopped

const BUTTON_HOLD_LIMIT = 200 # causes bugs: 50

@export var nextRotation: PackedScene
@export var moveTimerWaitTime: float = 0.5
@export var tint: Color = Color.BLACK
var lastForcedLeftMovementTimestamp = 0
var lastForcedRightMovementTimestamp = 0
var lastForcedDownMovementTimestamp = 0
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
var rotations = []
var rotationVariant = 0
var hasEmittedMovementStoppedSignal = false
var shouldRetryRotationInNextFrame = false

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
	if (rotations.size() > 0):
		for n in randi() % rotations.size():
			rotateShape()

func _process(delta):
	if canMove():
		if shouldRetryRotationInNextFrame:
			shouldRetryRotationInNextFrame = false
			rotateShape()
		if Input.is_action_pressed("shape_move_left") && not Input.is_action_pressed("shape_move_right"):
			if Time.get_ticks_msec() - lastForcedLeftMovementTimestamp > BUTTON_HOLD_LIMIT:
				lastForcedLeftMovementTimestamp = Time.get_ticks_msec()
				for block in getChildBlocks():
					block.moveLeft()
		if Input.is_action_pressed("shape_move_right") && not Input.is_action_pressed("shape_move_left"):
			if Time.get_ticks_msec() - lastForcedRightMovementTimestamp > BUTTON_HOLD_LIMIT:
				lastForcedRightMovementTimestamp = Time.get_ticks_msec()
				for block in getChildBlocks():
					block.moveRight()
		if Input.is_action_pressed("shape_move_down"):
			if Time.get_ticks_msec() - lastForcedDownMovementTimestamp > BUTTON_HOLD_LIMIT:
				lastForcedDownMovementTimestamp = Time.get_ticks_msec()
				for block in getChildBlocks():
					block.moveDown()
		if Input.is_action_just_pressed("shape_rotate"):
			rotateShape()

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
	return possibleColors[randi() % possibleColors.size()]

func onMovementStopped():
	if !hasEmittedMovementStoppedSignal:
		movement_stopped.emit()
		hasEmittedMovementStoppedSignal = true
	
