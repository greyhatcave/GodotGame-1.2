extends Node2D

onready var player = get_node("/root/Level01/Player")

var damage = 50
const ROTATION_SPEED = 90.0
var damage_on_queue = 0.0
var player_inside_flame # Boolean

func _process(delta):
	var target_rotation = (player.get_position() - global_position).angle()

	# Calculate how much enemy needs to rotate to reach target_rotation.
	var distance = wrapf(target_rotation - rotation, -PI, PI)

	# Calculate maximum rotation in one frame.
	var rotate = sign(distance)*ROTATION_SPEED * delta

	if abs(rotate) >= abs(distance): # If target can be reached within the frame
		rotation = target_rotation
	else:
		rotation += rotate
		
	if player_inside_flame == true:
		var dps = damage * delta
		damage_on_queue += dps
		
	if damage_on_queue > 0.0:
		player.PlayerOnHit(damage_on_queue)
		damage_on_queue = 0

func _on_Flame_body_entered(body): 
	if body.is_in_group("Player"): # if Player entered flame
		player_inside_flame = true

func _on_Flame_body_exited(body): 
	if body.is_in_group("Player"): # if Player exited flame
		player_inside_flame = false
