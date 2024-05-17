extends Path3D

@export var speed: float = 1.0
@export var pauseTimeAtWaypoints: float = 1.0
@export var pauseAtStartStop: bool
@export var jumpToStart: bool
@export var easingToPoints: bool
@export var easeFactor: float = 1.0
@export var isLoop: bool


var totalCurveLength: float
var nWayPoints: int
var curWaypointId: int
var waypointRatios: Array

var moving: bool
var moveFrom: float
var moveTo: float
var moveTime: float
var moveDelay: float
var moveDirection = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	var c = self.get_curve()
	nWayPoints = c.point_count
	totalCurveLength = c.get_baked_length() 
	var curLength = 0
	for i in nWayPoints:
		if i > 0:
			var r1 = c.get_closest_offset(c.get_point_position(i-1))
			var r2 = c.get_closest_offset(c.get_point_position(i))
			curLength += r2-r1
		waypointRatios.append(curLength/totalCurveLength)
	
	if isLoop:
		var r1 = c.get_closest_offset(c.get_point_position(nWayPoints))
		var r2 = c.get_closest_offset(c.get_point_position(1))
		curLength += r2-r1
		waypointRatios.append(curLength/totalCurveLength)
	
	$PathFollow3D.progress_ratio = 0
	curWaypointId = 0	
	
	if pauseTimeAtWaypoints > 0:
		var timer = get_tree().create_timer(pauseTimeAtWaypoints)
		timer.timeout.connect(start_moving)
	else:
		start_moving()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isLoop:
		$PathFollow3D.progress_ratio += speed/(100*totalCurveLength)
		return	
		
	if !moving:
		return
	
	if moveDelay < moveTime:
		moveDelay += delta
		var t 
		if pauseTimeAtWaypoints > 0:
			if easingToPoints:
				t = ease_in_out_quart(0,easeFactor,moveDelay/moveTime)
			else:
				t = moveDelay/moveTime
		else:
			t = moveDelay/moveTime
		
		$PathFollow3D.progress_ratio = lerp(moveFrom,moveTo,t)
		
	else:
		$PathFollow3D.progress_ratio = moveTo
		moving = false
		waypoint_reached()
		
func start_moving():
	
	curWaypointId += moveDirection

	if curWaypointId == nWayPoints-1:
		#print(curWaypointId)
		if jumpToStart:
			curWaypointId = 1
		else:
			moveDirection = -1
			curWaypointId -= 2
			#print(curWaypointId)
	elif curWaypointId == -1:
		moveDirection = 1
		curWaypointId += 2
	
	moveFrom = waypointRatios[curWaypointId-moveDirection]
	moveTo = waypointRatios[curWaypointId]
	moveTime = abs(moveTo-moveFrom) * totalCurveLength / speed
	moveDelay = 0
	moving = true
	
	
func waypoint_reached():
			
	if pauseTimeAtWaypoints > 0:
		if pauseAtStartStop:
			if curWaypointId == 0 || curWaypointId == (nWayPoints-2):
				var timer = get_tree().create_timer(pauseTimeAtWaypoints)
				timer.timeout.connect(start_moving)
			else:
				start_moving()	
		else:		
			var timer = get_tree().create_timer(pauseTimeAtWaypoints)
			timer.timeout.connect(start_moving)		
	else:
		start_moving()
			
static func ease_in_out_quart(start: float, end: float, value: float) -> float:
	value /= 0.5
	end -= start
	
	if value < 1:
		return end * 0.5 * value * value * value * value + start
		
	value -= 2
	return -end * 0.5 * (value * value * value * value - 2) + start
