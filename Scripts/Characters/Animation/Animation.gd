extends "res://Scripts/Characters/Animation/Skeleton.gd"


export (Vector2) var min_max_interpolation = Vector2(0.0, 0.9)
export (float) var foot_height_offset = 0.2

#IK variables
onready var target_left = $Target_left #targets for the feet
onready var target_right = $Target_right
onready var raycast_left = $RayCast_left #raycasts that detect weather player is on the floor
onready var raycast_right  = $RayCast_right
onready var ik_left = $Armature001/Skeleton/SkeletonIK_left_foot #gets the skeletonIK bones
onready var ik_right = $Armature001/Skeleton/SkeletonIK_right_foot
onready var foot_left = $Armature001/Skeleton/Left_foot #gets the feet we apply the skeletonIK to
onready var foot_right = $Armature001/Skeleton/Right_foot
onready var no_raycast_pos_l = $no_raycast_pos_l #gets the 
onready var no_raycast_pos_r = $no_raycast_pos_r

#physical_skeleton
onready var skeleton = $Armature001/Skeleton

func _ready():
	#start IK
	ik_right.start()
	ik_left.start()
	
	#skeleton.physical_bones_start_simulation() #make sure the shoulder physical bones are always set to the translatiopn of the shoulder bones

func update_ik_target_pos(target, raycast, no_raycast_pos, foot_pos, foot_heighy_offset):
	if raycast.is_colliding(): #if raycast is on ground
		var hit_point = raycast.get_collision_point().y + foot_height_offset #gets Y position of where the ground is.
		target.global_transform.origin.y = hit_point #sets the target to the y position of the hitpoint
	else:
		target.global_transform.origin.y = no_raycast_pos.global_transform.origin.y #if the raycast not colliding, the player is in the air and so the target position is set to the no_raycast_pos

func _physics_process(_delta):
	#update target_pos each frame
	update_ik_target_pos(target_left, raycast_left, no_raycast_pos_l, foot_left, foot_height_offset)
	update_ik_target_pos(target_right, raycast_right, no_raycast_pos_r, foot_right, foot_height_offset)
	
	#update interpolation each frame
	ik_right.interpolation = clamp($Interpolation_right.transform.origin.y, min_max_interpolation.x, min_max_interpolation.y)
	ik_left.interpolation = clamp($Interpolation_left.transform.origin.y, min_max_interpolation.x, min_max_interpolation.y)
