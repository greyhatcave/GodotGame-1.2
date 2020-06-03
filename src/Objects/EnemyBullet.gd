extends Area2D


var move = Vector2.ZERO
var look_vec = Vector2.ZERO
var player = null
var speed = 5



func _ready():
	
	look_vec = player.position - global_position
	
func _physics_process(delta):
	
	move = move.move_toward(look_vec, delta)
	move = move.normalized() * speed
	position += move
