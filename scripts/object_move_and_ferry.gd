extends PathFollow3D

@export var speed: float = 3.0
@export var pauseTimeAtBeginAndEnd: float = 1.0
var move_direction: int = -1
# Called when the node enters the scene tree for the first time.
func _ready():
	var timer = get_tree().create_timer(pauseTimeAtBeginAndEnd)
	timer.timeout.connect(toggle_direction)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(move_direction)
	progress_ratio += (delta*(speed/100))*move_direction
	if progress_ratio == 0:
		var timer = get_tree().create_timer(pauseTimeAtBeginAndEnd)
		timer.timeout.connect(toggle_direction)
	if progress_ratio == 1:
		var timer = get_tree().create_timer(pauseTimeAtBeginAndEnd)
		timer.timeout.connect(toggle_direction)
		
func toggle_direction():
	move_direction = move_direction * - 1
