extends "res://Scripts/Characters/Character.gd"

export var camera_rotation_speed = 350

onready var camera = $CameraRig/Camera
onready var camera_rig = $CameraRig

onready var anim_tree = $AnimationTree
var relative_vel = Vector3()

func _ready():
	camera_rig.set_as_toplevel(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _input(_event):
	if Input.is_action_just_pressed("pause"):
		get_tree().quit()

func _physics_process(delta):
	camera_follow_player()
	
	run(delta)
	
	anim_tree.set("parameters/StateMachine/BlendSpace1D/blend_position", vel.length())

func camera_follow_player():
	#camera follows player
	var player_pos = global_transform.origin
	camera_rig.global_transform.origin = player_pos

func run(delta):
	move_direction = Vector3()
	#set moved direction based on key inputs and mouse pos
	var camera_basis = camera.get_global_transform().basis
	if Input.is_action_pressed("forward"):
		move_direction -= camera_basis.z
	elif Input.is_action_pressed("back"):
		move_direction += camera_basis.z
	if Input.is_action_pressed("left"):
		move_direction -= camera_basis.x
	elif Input.is_action_pressed("right"):
		move_direction += camera_basis.x
	move_direction.y = 0
	move_direction = move_direction.normalized()
	
	vel += move_direction * speed * delta

	#check what input is being pressed and find x and z values and multiply by velocity length
