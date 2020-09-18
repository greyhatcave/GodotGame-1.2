extends Node2D




#onready var parent = get_parent()
#
#var timer = null
#var bullet_delay = 0.4
#var can_shoot = true
#var fireball = preload("res://src/Objects/Fireball.tscn")
#
#export var fireball_speed = 1500
#
#
#
#func _ready():
#	timer = Timer.new()
#	timer.set_one_shot(true)
#	timer.set_wait_time(bullet_delay)
#	timer.connect("timeout", self, "on_timeout_complete")
#	add_child(timer)
#
#func on_timeout_complete():
#	can_shoot = true
#
#
#func _process(_delta):
#	look_at(get_global_mouse_position())
#
#	if parent.current_weapon == 1:
#		shoot(_delta)
#
#
#func shoot(_delta):
#	if Globals.normal_bullets >= 1:
#		if Input.is_action_just_pressed("fire") && can_shoot:
#			Globals.normal_bullets -= 1
#			var fireball_instance = fireball.instance()
#			fireball_instance.position = $Shotgun/Node2D.get_global_position()
#			if parent.velocity:
#				fireball_instance.apply_impulse(Vector2(), Vector2(fireball_speed, 0).rotated(rotation + rand_range(-0.13, 0.13)))
#			elif Input.is_action_just_pressed("crouch"):
#				fireball_instance.apply_impulse(Vector2(), Vector2(fireball_speed, 0).rotated(rotation))
#			if !parent.velocity:
#				fireball_instance.apply_impulse(Vector2(), Vector2(fireball_speed, 0).rotated(rotation + rand_range(-0.05, 0.05)))
#			get_tree().get_root().add_child(fireball_instance)
#			can_shoot = false
#			timer.start()
