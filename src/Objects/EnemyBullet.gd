extends Area2D

var move = Vector2.ZERO
var look_vec = Vector2.ZERO
var player = null
var speed = 9
var damage = 5

onready var parent = get_parent()
#onready var anim_player = $AnimatedSprite

func _ready():
	if $Bullet_Animation.frame == 0:
		$Bullet_Animation.play()
	if player:
		look_vec = player.position - global_position
		### flip to player position
		#if look_vec.x < 0:
		#	$AnimatedSprite.flip_h = true
		#if look_vec.x > 0:
		#	$AnimatedSprite.flip_h = false
		
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

func _on_Bullet_Animation_frame_changed():
	if $Bullet_Animation.frame == 2:
#		print("FRAME 2")
		$Bullet_Animation.stop()
