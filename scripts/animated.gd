class_name animated extends Node


var raycast
@onready var parent: Node = get_parent()
# always place as a direct child of the node you want to animate

## CONFIG

@export var spinning: bool
@export var spin_speed: int = 1

@export var sliding: bool
@export var slide_on_axis_x: bool
@export var slide_on_axis_z: bool
@export var x_bounce_amplitude: float = 1
@export var x_bounce_frequency: float = 1
@export var x_offset: float = 1.0
@export var z_bounce_amplitude: float = 1
@export var z_bounce_frequency: float = 1
@export var z_offset: float = 1.0


@export var bouncing: bool
@export var y_bounce_amplitude: float = 1
@export var y_bounce_frequency: float = 1
@export var y_offset: float = 1.0

var time: float
var current_y_local_position: float

func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	
	if bouncing:
		parent.position.y = (sin(time*y_bounce_frequency)*y_bounce_amplitude)+y_offset

	if spinning:
		parent.rotation.y += delta*spin_speed
	
	if sliding:
		if slide_on_axis_x:
			parent.position.x = (sin(time*x_bounce_frequency)*x_bounce_amplitude)+x_offset
		if slide_on_axis_z:
			parent.position.z = (sin(time*z_bounce_frequency)*z_bounce_amplitude)+z_offset
	
