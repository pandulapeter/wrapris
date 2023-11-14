extends BaseShape

func _ready():
	initialize(
		[
			[
				Vector2(1,-1),
				Vector2.ZERO,
				Vector2(-1,1),
				Vector2(-2,2)
			],
			[
				Vector2(2,2),
				Vector2(1,1),
				Vector2.ZERO,
				Vector2(-1,-1)
			],
			[
				Vector2(-1,1),
				Vector2.ZERO,
				Vector2(1,-1),
				Vector2(2,-2)
			],
			[
				Vector2(-2,-2),
				Vector2(-1,-1),
				Vector2.ZERO,
				Vector2(1,1)
			]
		]
	)
