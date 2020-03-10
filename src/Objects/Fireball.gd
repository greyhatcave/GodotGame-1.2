extends RigidBody2D

func _on_Fireball_body_entered(body):
	queue_free()
