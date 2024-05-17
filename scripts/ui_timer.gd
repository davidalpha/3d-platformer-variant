extends Label

var time: float

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	var secs = fmod(time,60)
	var mins = fmod(time,60*60) / 60
	
	var time_passed = "%02d : %02d" % [mins,secs]
	
	text = time_passed
