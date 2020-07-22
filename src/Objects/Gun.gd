extends KinematicBody2D

onready var parent = get_parent()
var fireball = preload("res://src/Objects/Fireball.tscn")

export var fireball_speed = 4000


func _process(_delta):
	look_at(get_global_mouse_position())
	shoot(fireball)
		
		
# Call shoot in player.tscn::1 with 'child'
func shoot(_delta):
	if Input.is_action_just_pressed("fire"):
		var fireball_instance = fireball.instance()
		fireball_instance.position = $FirePointer.get_global_position()
		fireball_instance.rotation_degrees = rotation_degrees
		if parent.velocity:
			fireball_instance.apply_impulse(Vector2(), Vector2(fireball_speed, 0).rotated(rotation + rand_range(-0.13, 0.13)))
		elif Input.is_action_just_pressed("crouch"):
			fireball_instance.apply_impulse(Vector2(), Vector2(fireball_speed, 0).rotated(rotation))
		if !parent.velocity:
			fireball_instance.apply_impulse(Vector2(), Vector2(fireball_speed, 0).rotated(rotation + rand_range(-0.05, 0.05)))
		get_tree().get_root().add_child(fireball_instance)
