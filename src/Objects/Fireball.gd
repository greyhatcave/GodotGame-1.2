extends RigidBody2D

var damage = 1
var fire_direction
var origin


func _on_Fireball_body_entered(body):
	if body.is_in_group("Enemies"):
		body.OnHit(damage)
	queue_free()

