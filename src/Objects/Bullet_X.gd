extends RigidBody2D
#extends Area2D

var projectile_speed = 1100
var life_time = 0.4
var damage = 0.1

func _ready():
#	apply_impulse(Vector2(), Vector2(projectile_speed, 0).rotated(rotation))
	apply_impulse(Vector2(), Vector2(projectile_speed, 0).rotated(rotation + rand_range(-0.3, 0.3)))
	SelfDestruct()

func SelfDestruct():
	yield(get_tree().create_timer(life_time), "timeout")
	queue_free()

func _on_Bullet_X_body_entered(body):
	if body.is_in_group("Enemies"):
		body.OnHit(damage)
	self.hide()
