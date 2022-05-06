extends Spatial


export (Vector2) var min_max_interpolation = Vector2(0.0, 0.9)
export (float) var foot_offset = 0.15
export (float) var ik_raycast_height = 0

onready var target_left = $Target_left #targets for the feet
onready var target_right = $Target_right
onready var raycast_left = $RayCast_left #raycasts that detect weather player is on the floor
onready var raycast_right  = $RayCast_right
onready var ik_left = $Armature001/Skeleton/SkeletonIK_left_foot
onready var ik_right = $Armature001/Skeleton/SkeletonIK_right_foot
onready var foot_left = $Armature001/Skeleton/Left_foot
onready var foot_right = $Armature001/Skeleton/Right_foot
onready var no_raycast_pos_l = $no_raycast_pos_l
onready var no_raycast_pos_r = $no_raycast_pos_r

func _ready():
	ik_right.start()
	ik_left.start()

func update_ik_target_pos(target, raycast, raycast_height_offset, hit_offset, no_raycast_pos, foot_pos):
	if raycast.is_colliding():
		var hit_point = raycast.get_collision_point().y + hit_offset#gets Y position of where the ground is.
		target.global_transform.origin.y = hit_point #sets the target to the y position of the hitpoint
	else:
		target.global_transform.origin.y = no_raycast_pos.global_transform.origin.y

func _physics_process(_delta):
	update_ik_target_pos(target_left, raycast_left, ik_raycast_height, foot_offset, no_raycast_pos_l, foot_left)
	update_ik_target_pos(target_right, raycast_right, ik_raycast_height, foot_offset, no_raycast_pos_r, foot_right)
	ik_right.interpolation = clamp($Interpolation_right.transform.origin.y, min_max_interpolation.x, min_max_interpolation.y)
	ik_left.interpolation = clamp($Interpolation_left.transform.origin.y, min_max_interpolation.x, min_max_interpolation.y)
	print (ik_left.interpolation)
