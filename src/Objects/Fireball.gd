extends RigidBody2D

export var speed = 1000.0


var projectile_speed = 1500
var life_time = 3
var damage = 10


func _ready():
	apply_impulse(Vector2(), Vector2(projectile_speed, 0).rotated(rotation))
	
	SelfDestruct()

func SelfDestruct():
	yield(get_tree().create_timer(life_time), "timeout")
	queue_free()

func _on_Fireball_body_entered(body):
	if body.is_in_group("Enemies"):
		body.OnHit(damage)
	self.hide()
