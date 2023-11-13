extends Node2D

@export var tint: Color = Color.WHITE
@export var shouldShowDebugInfo: bool = false
@export var movementSpeed: float = -1
@export var isMoving: bool = true
@export var moveTimerWaitTime: float = 0.5
var normalizedDestination: Vector2
var normalizedDestinationInNextFrame: Vector2
var shapeId = ""
var normalizedViewportSize: Vector2

func _ready():
	normalizedViewportSize = normalizePosition(get_viewport().size)
	
	# Snap to the grid
	var normalizedPosition = normalizePosition(global_position)
	global_position = denormalizePosition(normalizedPosition)
	
	# Initialize the movement
	normalizedDestination = normalizedPosition
	normalizedDestinationInNextFrame = normalizedPosition
	if movementSpeed <= 0:
		movementSpeed = $"/root/Shared".blockMovementSpeed
	
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
		
	# Handle debugging
	$Label.visible = shouldShowDebugInfo
	refreshDebugText()

func _process(delta):
	if normalizedDestinationInNextFrame != normalizedDestination:
		normalizedDestination = normalizedDestinationInNextFrame
		refreshDebugText()
	
	# Input handling
	if Input.is_action_just_pressed("shape_move_left"):
		moveLeft()
	if Input.is_action_just_pressed("shape_move_right"):
		moveRight()
	if Input.is_action_just_pressed("shape_move_down"):
		moveDown()
		
	# Move towards the destination
	var destination = denormalizePosition(normalizedDestination)
	if global_position != destination:
		global_position = lerp(global_position, destination, movementSpeed)

func refreshDebugText():
	if (shouldShowDebugInfo):
		$Label.text = str(normalizedDestination) + "\n" + str(isMoving)

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

func moveLeft():
	move(Vector2.LEFT)

func moveRight():
	move(Vector2.RIGHT)

func moveDown():
	if !move(Vector2.DOWN):
		isMoving = false

func getBlocksInSameShape():
	if shapeId == null:
		return []
	else:
		return get_tree().get_nodes_in_group(shapeId)

func canMoveToDirection(direction: Vector2):
	if not isMoving:
		return false
	var targetPosition = calculateFutureDestination(direction)
	if targetPosition.y > normalizedViewportSize.y:
		return false
	var isTargetPositionFree = true
	for block in get_tree().get_nodes_in_group("blocks"):
		if block.normalizedDestination == targetPosition:
			if shapeId == null || not block.is_in_group(shapeId):
				isTargetPositionFree = false
	return isTargetPositionFree

func calculateFutureDestination(direction: Vector2):
	var target = normalizedDestination + direction
	return Vector2(
		wrapf(target.x, 1, normalizedViewportSize.x + 1),
		target.y
	)

func move(direction: Vector2):
	# Check that the target position is empty, or is occupied by
	# other blocks from the very same shape
	var canMove = canMoveToDirection(direction)
	for block in getBlocksInSameShape():
		if not block.canMoveToDirection(direction):
			canMove = false
	if canMove:
		normalizedDestinationInNextFrame = calculateFutureDestination(direction)
	refreshDebugText()
	return canMove

func _on_move_timer_timeout():
	moveDown()
