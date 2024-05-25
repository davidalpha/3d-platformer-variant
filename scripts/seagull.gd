extends AnimatableBody3D

var rotate_speed = .5
var radius = 10
var centre
var angle = 0
var movement_speed = .1
var edible = false

# state booleans
var angled_left = false
var angled_right = false
var angled_up = false
var angled_down = false
var move_forward = false
var move_up = false
var move_down = false
var move_in_circle_left = false
var move_in_circle_right = false
@export var scale_factor = 1.0



# timekeeping
var frames = 300
var frame_threshold = 300 #5 seconds

func _ready():
	$AnimationPlayer.play("flying")
	$AnimationPlayer.speed_scale = 1.5
	add_to_group("gulls")
	
func _physics_process(delta):
	
	# every 5 seconds, pick a new behavior and reset	
	if frames > frame_threshold:
		# reset booleans and time:
		angled_left = false
		angled_right = false
		angled_up = false
		angled_down = false
		move_forward = false
		move_up = false
		move_down = false
		move_in_circle_left = false
		move_in_circle_right = false
		frames = 0

		# reset all rotations except the direction you're facing towards
		var y_rotation = transform.basis.get_euler().y
		transform.basis = Basis()
		rotate_y(y_rotation)

		# pick new behavior:
		var behavior = randi() % 5
		if behavior == 0:
			move_forward = true
		elif behavior == 1:
			move_up = true
		elif behavior == 2:
			if position.y < 35:
				move_up = true
			else:
				move_down = true
		elif behavior == 3:
			move_in_circle_left = true
		elif behavior == 4:
			move_in_circle_right = true
		move_in_circle_left = true

	# execute chosen behavior
	if move_forward:
		_move_forward(delta)
	elif move_up:
		_move_up(delta)
	elif move_down:
		_move_down(delta)
	elif move_in_circle_left:
		_move_in_circle_left(delta)
	elif move_in_circle_right:
		_move_in_circle_right(delta)

	frames += 1
	self.scale = Vector3(scale_factor, scale_factor, scale_factor)
	

	
func _move_forward(delta):
	var velocity_direction = global_transform.basis.get_rotation_quaternion() * Vector3.FORWARD*-1
	move_and_collide(velocity_direction * movement_speed)
	
func _move_up(delta):
	if not angled_up:
		rotation_degrees.x = -25
		angled_up = true
		
	# get angled up vector. 
	var velocity_direction = transform.basis.get_rotation_quaternion() * Vector3.FORWARD*-1
	velocity_direction.y = .3
	move_and_collide(velocity_direction*movement_speed)

func _move_down(delta):
	if not angled_down:
		rotation_degrees.x = 25
		angled_down = true
		
	# get angled up vector. 
	var velocity_direction = transform.basis.get_rotation_quaternion() * Vector3.FORWARD*-1
	velocity_direction.y = -.3
	move_and_collide(velocity_direction*movement_speed)

func _move_in_circle_left(delta):
	if not angled_left:
		rotation_degrees.z = -30
		angled_left = true
	
	centre = Vector2(global_transform.origin.x, global_transform.origin.z)
	angle += rotate_speed * delta;

	var offset = Vector2(sin(angle), cos(angle)) * radius;
	var pos = centre + offset
	var velocity_vector = (pos - centre).normalized() * movement_speed
	var look_angle =  velocity_vector.angle()
	
	# rotate player character towards movement direction
	# first calculate the correct angle
	var direction_vec2 = velocity_vector
	var current_direction_vec2 = Vector2(global_transform.basis.z.x, global_transform.basis.z.z)
	var direction_angle = current_direction_vec2.angle_to(direction_vec2) *-1
	
	# Then lerp towards that angle using Quats
	var target_rotation = global_transform.basis.rotated(Vector3.UP, direction_angle).get_rotation_quaternion()
	global_transform.basis = Basis(target_rotation)
	
	self.move_and_collide(Vector3(velocity_vector.x, 0, velocity_vector.y)) 
	
func _move_in_circle_right(delta):
	if not angled_right:
		rotation_degrees.z = 30
		angled_right = true
	
	centre = Vector2(global_transform.origin.x, global_transform.origin.z)
	angle += rotate_speed *-1 * delta;

	var offset = Vector2(sin(angle), cos(angle)) * radius;
	var pos = centre + offset
	var velocity_vector = (pos - centre).normalized() * movement_speed
	var look_angle =  velocity_vector.angle()
	
	# rotate player character towards movement direction
	# first calculate the correct angle
	var direction_vec2 = velocity_vector
	var current_direction_vec2 = Vector2(transform.basis.z.x, transform.basis.z.z)
	var direction_angle = current_direction_vec2.angle_to(direction_vec2) *-1
	
	# Then lerp towards that angle using Quats
	var current_rotation = global_transform.basis.get_rotation_quaternion()
	var target_rotation = global_transform.basis.rotated(Vector3.UP, direction_angle).get_rotation_quaternion()
	global_transform.basis = Basis(current_rotation.slerp(target_rotation, .3))
	
	self.move_and_collide(Vector3(velocity_vector.x, 0, velocity_vector.y)) 

func _destroy():
	queue_free()
