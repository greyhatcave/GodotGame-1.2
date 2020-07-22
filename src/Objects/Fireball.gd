extends RigidBody2D

var damage = 1


func _on_Fireball_body_entered(body):
	if body.is_in_group("Enemies"):
		print("Target Hit")
		body.OnHit(damage)
	queue_free()

