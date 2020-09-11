extends RigidBody2D

var projectile_speed = 1200
var life_time = 0.5
var damage = 1


func _ready():
	apply_impulse(Vector2(), Vector2(projectile_speed, 0).rotated(rotation))
	SelfDestruct()

func SelfDestruct():
	yield(get_tree().create_timer(life_time), "timeout")
	queue_free()

func _on_New_Gun_Projectile_body_entered(body):
	if body.is_in_group("Enemies"):
		body.OnHit(damage)
	self.hide()
