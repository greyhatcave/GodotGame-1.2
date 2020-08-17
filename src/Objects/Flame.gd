extends Node2D

onready var player = get_node("/root/Level01/Player")

var target
var damage = 10
const ROTATION_SPEED = 90.0

var damage_on_queue = 0.0
#var damage_speed = 1.0

var  player_inside_flame

#func take_damage(duration, damage): # queue damage and set speed
#	damage_on_queue += damage
#	damage_speed = damage / duration

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
		
#	if player_inside_flame == true:
#		damage_on_queue += delta * damage

#	if damage_on_queue > 0.0:
#		var damage = delta * damage_speed
#		if damage > damage_on_queue:
#			damage = damage_on_queue
#		damage_on_queue -= damage # Apply damage
#		print(damage_on_queue)

func _on_Flame_body_entered(body): 
	if body.is_in_group("Player"): # if Player entered flame
		player_inside_flame = true
		print("Player inside flame: ", player_inside_flame)
	

func _on_Flame_body_exited(body): 
	if body.is_in_group("Player"): # if Player exited flame
		player_inside_flame = false
		print("Player inside flame: ", player_inside_flame)
