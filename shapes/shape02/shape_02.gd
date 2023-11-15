extends BaseShape


func _ready():
	initialize(
		[
			[
				Vector2(1,0),
				Vector2(0,1),
				Vector2(-1,0),
				Vector2(0,-1)
			],
			[
				Vector2(0,1),
				Vector2(-1,0),
				Vector2(0,-1),
				Vector2(1,0)
			],
			[
				Vector2(-1,0),
				Vector2(0,-1),
				Vector2(1,0),
				Vector2(0,1)
			],
			[
				Vector2(0,-1),
				Vector2(1,0),
				Vector2(0,1),
				Vector2(-1,0)
			]
		]
	)
