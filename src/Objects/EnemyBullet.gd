extends Area2D


var move = Vector2.ZERO
var look_vec = Vector2.ZERO
var player = null
var speed = 7
var damage = 10



func _ready():
	if player:
		look_vec = player.position - global_position
	
func _physics_process(delta):
	
	move = move.move_toward(look_vec, delta)
	move = move.normalized() * speed
	position += move


func _on_Fireball_body_entered(body):
	if body.is_in_group("Player"):
		body.PlayerOnHit(damage)
		queue_free()



func _on_Fireball_body_entereds(body):
	if body.is_in_group("World"):
		queue_free()
