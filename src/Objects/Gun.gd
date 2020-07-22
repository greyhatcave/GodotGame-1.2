extends KinematicBody2D


var fireball = preload("res://src/Objects/Fireball.tscn")
export var fireball_speed = 4000


func _process(_delta):
	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("fire"):
		var fireball_instance = fireball.instance()
		fireball_instance.position = $FirePointer.get_global_position()
		fireball_instance.rotation_degrees = rotation_degrees
		fireball_instance.apply_impulse(Vector2(), Vector2(fireball_speed, 0).rotated(rotation))
		get_tree().get_root().add_child(fireball_instance)
