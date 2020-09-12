extends KinematicBody2D

onready var parent = get_parent()

var timer = null
var fire_rate = 0.7
var bullet_delay = 0.1
var can_fire = true
var fireball = preload("res://src/Objects/New_Gun_Projectile.tscn")


func _ready():
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(bullet_delay)
	timer.connect("timeout", self, "on_timeout_complete")
	add_child(timer)

func on_timeout_complete():
	can_fire = true


func _process(_delta):
	
	if parent.current_weapon == 2:
		shoot(_delta)


func shoot(_delta):
	if Globals.shotgun_bullets >= 1:
		if Input.is_action_pressed("fire") and can_fire == true:
			Globals.shotgun_bullets -= 1
			var projectiles_angles = [0]
			var projectiles = 4
			for i in range(1, projectiles * 2):
				var num = float(i) / 8
				projectiles_angles.append(num)
				projectiles_angles.append(num * -1)
		
			for i in range(projectiles):
				var bullet_instance = fireball.instance()
				var angle = get_angle_to(get_global_mouse_position())
				angle += projectiles_angles[i]
				bullet_instance.position = $FirePointer.global_position
				bullet_instance.rotation = angle
				get_tree().get_root().add_child(bullet_instance)
		
			can_fire = false
			yield(get_tree().create_timer(fire_rate), "timeout")
			can_fire = true
