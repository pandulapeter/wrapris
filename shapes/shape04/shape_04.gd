extends BaseShape

func _ready():
	initialize(
		[
			[
				Vector2.ZERO,
				Vector2(0,-2),
				Vector2(-1,-1),
				Vector2(-2,0)
			],
			[
				Vector2.ZERO,
				Vector2(2,0),
				Vector2(1,-1),
				Vector2(0,-2)
			],
			[
				Vector2.ZERO,
				Vector2(0,2),
				Vector2(1,1),
				Vector2(2,0)
			],
			[
				Vector2.ZERO,
				Vector2(-2,0),
				Vector2(-1,1),
				Vector2(0,2)
			]
		]
	)
