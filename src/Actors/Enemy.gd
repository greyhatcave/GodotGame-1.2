extends Actor


var max_hp = 3
var current_hp


func _ready() -> void:
	set_physics_process(false)
	_velocity.x = -speed.x
	current_hp = max_hp

func OnHit(damage):
	print("I got hit")
	current_hp -= damage
	get_node("HealthBar").value = int((float(current_hp) / max_hp) * 100)
	if current_hp <= 0:
		$AnimatedSprite.play("enemy_dead")



func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
	if is_on_wall():
		_velocity.x *= -1.0
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y
	
	if _velocity.x > 0:
		if current_hp >= 1:
			get_node("AnimatedSprite").play("enemy_run")
	if _velocity.x <= -1.0:
		$AnimatedSprite.flip_h = true
	elif _velocity.x > 0:
			$AnimatedSprite.flip_h = false
	


func _on_AnimatedSprite_animation_finished():
	if current_hp <= 0:
		queue_free()
