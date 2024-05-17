extends PathFollow3D

@export var speed: float = 3.0
@export var pauseTimeAtBeginAndEnd: float = 1.0
var move_direction: int = 1
var moving: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	var timer = get_tree().create_timer(pauseTimeAtBeginAndEnd)
	timer.timeout.connect(start_moving)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moving:
		progress_ratio += (delta*(speed/100))*move_direction
		
	if progress_ratio == 0:
		moving = false
		var timer = get_tree().create_timer(pauseTimeAtBeginAndEnd)
		timer.timeout.connect(start_moving)
		move_direction = 1
		
	if progress_ratio >= 1:
		moving = false
		var timer = get_tree().create_timer(pauseTimeAtBeginAndEnd)
		timer.timeout.connect(start_moving)
		move_direction = -1
		


func start_moving():
	moving = true
