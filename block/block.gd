extends Node2D

signal movement_stopped
signal row_completed

const MOVEMENT_SPEED = 0.25

@export var tint: Color = Color.WHITE
@export var isMoving: bool = true
@export var moveTimerWaitTime: float = 0.5
var normalizedDestination: Vector2
var normalizedDestinationInNextFrame: Vector2
var shapeId = ""
var normalizedViewportSize: Vector2
var isSettling = true

func _ready():
	# Snap to the grid
	var normalizedPosition = normalizePosition(global_position)
	global_position = denormalizePosition(normalizedPosition)
	
	# Set up clones for seamless wrapping
	normalizedViewportSize = normalizePosition(get_viewport().size)
	var cloneOffset = (normalizedViewportSize.x - 1) * calculateNormalizationScale() / scale.x
	$SpriteLeftClone.position.x -= cloneOffset
	$SpriteLeftClone.visible = true
	$SpriteRightClone.position.x += cloneOffset
	$SpriteRightClone.visible = true
	
	# Initialize the movement
	normalizedDestination = normalizedPosition
	normalizedDestinationInNextFrame = normalizedPosition
	
	# Register to the group
	initializeInheritedState("blocks")

func initializeInheritedState(groupName):
	add_to_group(groupName)
	if groupName != "blocks":
		shapeId = groupName
	
	# Initialize the timer
	$MoveTimer.wait_time = moveTimerWaitTime
	
	# Set the block color
	if tint != null:
		$Sprite.modulate = tint
		$SpriteLeftClone.modulate = tint
		$SpriteRightClone.modulate = tint

func _process(delta):
	if normalizedDestinationInNextFrame != normalizedDestination:
		normalizedDestination = normalizedDestinationInNextFrame
	
	# Move towards the destination
	var destination = denormalizePosition(normalizedDestination)
	if global_position != destination:
		global_position = lerp(global_position, destination, MOVEMENT_SPEED)
	
	# Move the actual block to the other edge after wrapping
	if abs(global_position.x - destination.x) <= 4:
		isSettling = false
		$Sprite.rotation = 0
		if (normalizedDestination.x != wrapf(normalizedDestination.x, 1, normalizedViewportSize.x + 1)):
			normalizedDestination = Vector2(
				wrapf(normalizedDestination.x, 1, normalizedViewportSize.x + 1),
				normalizedDestination.y
			)
			normalizedDestinationInNextFrame = normalizedDestination
			global_position = Vector2(
				denormalizePosition(normalizedDestination).x,
				global_position.y
			)
	else:
		isSettling = true

func calculateNormalizationScale():
	return $Sprite.texture.get_height() * scale.y

func normalizePosition(position: Vector2):
	var scale = calculateNormalizationScale()
	return Vector2(
		round(position.x / scale),
		round(position.y / scale)
	)

func denormalizePosition(position: Vector2):
	var scale = calculateNormalizationScale()
	return (position * scale) - (Vector2(1, 1) * scale / 2)

func getBlocksInSameShape():
	if shapeId == null:
		return []
	else:
		return get_tree().get_nodes_in_group(shapeId)

func canMoveToDirection(direction: Vector2):
	if not isMoving:
		return false
	var targetPosition = calculateFutureDestinationWithWrapping(direction)
	if targetPosition.y > normalizedViewportSize.y:
		return false
	var cloneOffset = normalizedViewportSize.x
	var targetPositionCloneLeft = Vector2(
		targetPosition.x - cloneOffset,
		targetPosition.y
	)
	var targetPositionCloneRight = Vector2(
		targetPosition.x + cloneOffset,
		targetPosition.y
	)
	var isTargetPositionFree = true
	for block in get_tree().get_nodes_in_group("blocks"):
		if (block.normalizedDestinationInNextFrame == targetPosition
			|| block.normalizedDestinationInNextFrame == targetPositionCloneLeft
			|| block.normalizedDestinationInNextFrame == targetPositionCloneRight):
			if shapeId == null || not block.is_in_group(shapeId):
				isTargetPositionFree = false
	return isTargetPositionFree

func calculateFutureDestinationWithoutWrapping(direction: Vector2):
	return normalizedDestination + direction

func calculateFutureDestinationWithWrapping(direction: Vector2):
	var target = calculateFutureDestinationWithoutWrapping(direction)
	return Vector2(
		wrapf(target.x, 1, normalizedViewportSize.x + 1),
		target.y
	)

func move(direction: Vector2):
	# Check that the target position is empty, or is occupied by
	# other blocks from the very same shape
	if direction != Vector2.ZERO:
		var canMove = canMoveToDirection(direction)
		for block in getBlocksInSameShape():
			if not block.canMoveToDirection(direction):
				canMove = false
		if canMove:
			global_position = denormalizePosition(normalizedDestination)
			normalizedDestinationInNextFrame = calculateFutureDestinationWithoutWrapping(direction)
		return canMove

func animateRotation():
	$AnimationPlayer.play("rotation")

func _on_move_timer_timeout():
	if !move(Vector2.DOWN):
		movement_stopped.emit()
		isMoving = false
		$MoveTimer.stop()
		verifyFullRow()

func verifyFullRow():
	var blocksInTheSameRow = 0
	var rowIndex = normalizedDestination.y
	for block in get_tree().get_nodes_in_group("blocks"):
		if block.normalizedDestination.y == rowIndex:
			blocksInTheSameRow += 1
	if normalizedViewportSize.x == blocksInTheSameRow:
		for block in get_tree().get_nodes_in_group("blocks"):
			if block.normalizedDestination.y == rowIndex:
				block.queue_free()
		row_completed.emit(rowIndex)
