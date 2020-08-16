extends RigidBody2D


var max_hp = 3
var current_hp

const VIRUS_ID = preload("res://src/Objects/New_VirusID.tscn")
onready var collider = $SpawnArea/CollisionShape2D
onready var box_collision = $CollisionShape2D

func _ready():
	current_hp = max_hp



func OnHit(damage):
	current_hp -= damage
	if current_hp <= 0:
		$Timer.start()
		$Particles2D.emitting = true
		$Sprite.visible = false
		explode()

func explode():
	box_collision.set_deferred("disabled",true)
	for i in range(10):
		var virus = VIRUS_ID.instance()
		virus.position = calculate_random_spawn_position()
		get_node("/root/Level01").call_deferred("add_child", virus)

func calculate_random_spawn_position():
	var spawn_radius = collider.shape.radius

	var random_angle = randf() * 2 * PI
	var random_radius = randf() * spawn_radius / 2 + spawn_radius / 2

	return collider.global_position + Vector2(cos(random_angle) * random_radius, sin(random_angle) * random_radius)



func _on_Timer_timeout():
	if $Particles2D.emitting == false:
		queue_free()
