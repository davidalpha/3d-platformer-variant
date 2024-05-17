class_name CameraPivot3P extends Node3D

var sensitivity:float = 1000.0

# Called when the node enters the scene tree for the first time.
func _ready():
	var camera = Camera3D.new()
	add_child(camera)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
