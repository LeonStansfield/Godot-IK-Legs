extends KinematicBody

export var speed = 50
export var friction = 0.85
export var gravity = 30
export var acceleration = 1

var move_direction = Vector3()
var gravity_vec = Vector3()
var vel = Vector3()
var movement = Vector3()
var snap

func _physics_process(delta):
	
	#gravity
	if is_on_floor():
		snap = -get_floor_normal()
		gravity_vec = Vector3.ZERO
	elif is_on_ceiling():
		gravity_vec = Vector3.ZERO
	else:
		snap = Vector3.DOWN
		gravity_vec += Vector3.DOWN * gravity * delta
	
	#sets velocity
	if vel.length() <= 0.1:
		vel = Vector3(0, 0, 0)
	vel *= friction
	
	vel = vel.linear_interpolate(move_direction * speed, acceleration * delta)
	movement = vel + gravity_vec
	move_and_slide_with_snap(movement, snap, Vector3.UP ,false, 4, PI/4, false)
	
	look_at_direction()


func look_at_direction():
	if vel != Vector3.ZERO:
		var lookdir = atan2(-vel.x, -vel.z)
		rotation.y = lerp(rotation.y, lookdir, 0.1)
