extends KinematicBody2D

onready var parent = get_parent()

var timer = null
var fire_rate = 0.7
var amount = 10
var bullet_delay = 0.1
var can_fire = true
var bullet_x = preload("res://src/Objects/Bullet_X.tscn")
onready var player = get_tree().get_root().get_node("Level01").get_node("Player")

onready var FiringPositions = $FiringPositions



func _ready():
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(bullet_delay)
	timer.connect("timeout", self, "on_timeout_complete")
	add_child(timer)

func on_timeout_complete():
	can_fire = true


func _process(_delta):
	parent.look_at(get_global_mouse_position())
	if player.current_weapon == 2:
		shoot(_delta)


func shoot(_delta):
	if Globals.shotgun_bullets >= 1:
		if Input.is_action_pressed("fire") and can_fire == true:
			Globals.shotgun_bullets -= 1
			for z in amount:
				var bullet_instance = bullet_x.instance()
				bullet_instance.position = $FiringPositions.get_global_position()
				bullet_instance.transform = $Position2D.global_transform
				get_tree().get_root().add_child(bullet_instance)
			can_fire = false
			yield(get_tree().create_timer(fire_rate), "timeout")
			can_fire = true
