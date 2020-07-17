extends Node2D

var damage = 5


const ROTATION_SPEED = 90.0

onready var player = get_node("/root/Level01/Player")



func _process(delta):
	var target_rotation = (player.get_position() - global_position).angle()

	# Calculate how much enemy needs to rotate to reach target_rotation.
	var distance = wrapf(target_rotation - rotation, -PI, PI)

	# Calculate maximum rotation in one frame.
	var rotate = sign(distance)*ROTATION_SPEED*delta

	if abs(rotate) >= abs(distance): # If target can be reached within the frame
		rotation = target_rotation
	else:
		rotation += rotate



##### TODO > Apply damage while player is being hit by flame #####

func _on_Flame_body_entered(body):
	if body.is_in_group("Player"):
		body.PlayerOnHit(damage)
