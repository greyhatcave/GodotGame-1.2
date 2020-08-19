extends RigidBody2D

var damage = 1

func _physics_process(_delta):
	if $Area2D/AnimatedSprite.frame == 21:
		queue_free()

func _on_Fireball_body_entered(body):
	$Fireball_Animation.hide()
	if body.is_in_group("Enemies"):
		$CollisionShape2D.set_deferred("disabled", true)
		body.OnHit(damage)
		$Area2D/AnimatedSprite.play("default")
	if body.is_in_group("Box"):
		body.OnHit(damage)
		if $CollisionShape2D.disabled == false:
			$CollisionShape2D.set_deferred("disabled", true)
		if !$Area2D/AnimatedSprite.play("default"):
			$Area2D/AnimatedSprite.play("default")
	else:
		if $CollisionShape2D.disabled == false:
			$CollisionShape2D.set_deferred("disabled", true)
		if !$Area2D/AnimatedSprite.play("default"):
			$Area2D/AnimatedSprite.play("default")

