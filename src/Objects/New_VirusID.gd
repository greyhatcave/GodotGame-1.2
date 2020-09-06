extends Area2D

var coin_value = 1

export var speed = 3500
export var steer_force = 3500.0

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var target = null
onready var player = get_tree().get_root().get_node("Level01").get_node("Player")


func _ready():
	$AnimationPlayer.play("New_Bounce")
	set_physics_process(false)

func _physics_process(delta):
	acceleration += seek()
	velocity += acceleration * delta
	velocity = velocity.clamped(speed)
	rotation = velocity.angle()
	position += velocity * delta


func start(_transform, _target):
	global_transform = _transform
	rotation += rand_range(-0.09, 0.09)
	velocity = transform.x * speed
	target = _target

func seek():
	var steer = Vector2.ZERO
	var desired = (player.position - get_global_position()).normalized() * speed
	steer = (desired - velocity).normalized() * steer_force
	return steer


func _on_New_VirusID_body_entered(body):
	if body.is_in_group("Player"):
		body.AddCoin(coin_value)
		Globals.points += 1
		queue_free()


func _on_Sight_body_entered(body):
	if body.is_in_group("Player"):
		set_physics_process(true)
