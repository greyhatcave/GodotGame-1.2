extends Area2D

var coin_value = 1

export var speed = 550
export var steer_force = 300.0
var parent = get_parent()

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var target = null

onready var degota = get_tree().get_root().get_node("Level01").get_node("Degota")
onready var player = get_tree().get_root().get_node("Level01").get_node("Player")


	#$AnimationPlayer.play("New_Bounce")
	#set_physics_process(false)

func _process(delta):
	if degota.can_fire == false:
		set_physics_process(true)

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



func _on_Launcher_body_shape_entered(body_id, body, body_shape, area_shape):
	queue_free()