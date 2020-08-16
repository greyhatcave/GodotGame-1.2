extends RigidBody2D

var damage = 1
var fire_direction
var origin


func _on_Fireball_body_entered(body):
	if body.is_in_group("Enemies"):
		body.OnHit(damage)
	queue_free()
	if body.is_in_group("Box"):
		body.OnHit(damage)
		queue_free()


func _on_Fireball_Animation_frame_changed():
	if $Fireball_Animation.frame == 2:
		print("FRAME 2")
		$Fireball_Animation.stop()
