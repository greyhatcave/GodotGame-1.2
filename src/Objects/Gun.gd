extends KinematicBody2D

onready var parent = get_parent()

var velocity = Vector2()
var timer = null
var bullet_delay = 0.4
var can_shoot = true
var fireball = preload("res://src/Objects/Fireball.tscn")

export var fireball_speed = 1500
onready var player = get_tree().get_root().get_node("Level01").get_node("Player")


func _ready():
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(bullet_delay)
	timer.connect("timeout", self, "on_timeout_complete")
	add_child(timer)

func on_timeout_complete():
	can_shoot = true


func _process(_delta):
	parent.look_at(get_global_mouse_position())

	if player.current_weapon == 1:
		shoot(_delta)


func shoot(_delta):
	if Globals.normal_bullets >= 1:
		if Input.is_action_just_pressed("fire") && can_shoot:
			Globals.normal_bullets -= 1
			var fireball_instance = fireball.instance()
#			fireball_instance.position = $FirePointer.get_global_position()
#			fireball_instance.transform = $FirePointer.global_transform
			fireball_instance.transform = $Position2D.global_transform
			if velocity:
				fireball_instance.apply_impulse(Vector2(), Vector2(fireball_speed, 0).rotated(rotation + rand_range(-0.13, 0.13)))
			elif Input.is_action_just_pressed("crouch"):
				fireball_instance.apply_impulse(Vector2(), Vector2(fireball_speed, 0).rotated(rotation))
			if velocity:
				fireball_instance.apply_impulse(Vector2(), Vector2(fireball_speed, 0).rotated(rotation + rand_range(-0.05, 0.05)))
			get_tree().get_root().add_child(fireball_instance)
			can_shoot = false
			timer.start()
