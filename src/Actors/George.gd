extends KinematicBody2D

const GRAVITY = 3000
const SPEED = 50
const FLOOR = Vector2(0, -1)

var velocity = Vector2()
var direction = 1
var max_hp = 6
var current_hp
var player_in_range
var player_in_sight
var player_position

var can_fire = true


onready var standing_collision = $CollisionShape2D
onready var BULLET_SCENE = preload("res://src/Objects/EnemyBullet.tscn")
onready var VIRUS_ID = preload("res://src/Objects/New_VirusID.tscn")
onready var player = get_parent().get_node("Player")
onready var anim_player = $AnimatedSprite


func _ready():
	$EnemyFSM.call_deferred("set_state", $EnemyFSM.states.george_chase)
	current_hp = max_hp

func _physics_process(delta):
	george_dead()
	flip_sprite_to_player()
	SightCheck()

func _apply_gravity(delta):
	velocity.y += GRAVITY * delta

func george_dead():
	if current_hp <= 0:
		$EnemyFSM.call_deferred("set_state", $EnemyFSM.states.george_dead)
		stop_flame()

func _walk():
	if current_hp >= 1:
		velocity = move_and_slide(velocity, FLOOR)
		velocity.x = SPEED * direction
	
		if direction == 1:
			$AnimatedSprite.flip_h = false
		else:
			$AnimatedSprite.flip_h = true
		
		velocity.y += GRAVITY
		
		if is_on_wall():
			direction = direction * -1
			$RayCast2D.position.x *= -1
			velocity.x = SPEED * direction
	
		if $RayCast2D.is_colliding() == false:
			direction = direction * -1
			$RayCast2D.position.x *= -1

func fire():
	if player_in_sight && current_hp > 0:
		can_fire = false
		$Weapon/Flame/Flame_Collision/Particles2D.emitting = true
		$Weapon/Flame.visible = true
		$Weapon/Flame/Flame_Collision.disabled = false
		can_fire = true

func stop_flame():
	$Weapon/Flame/Flame_Collision.disabled = true
	$Weapon/Flame/Flame_Collision/Particles2D.emitting = false

func OnHit(damage):
	current_hp -= damage
	get_node("HealthBar").value = int((float(current_hp) / max_hp) * 100)
	if current_hp <= 0:
		$HealthBar.hide()
		standing_collision.set_deferred("disabled",true)

func _on_AnimatedSprite_animation_finished():
	if current_hp <= 0:
		var virus = VIRUS_ID.instance()
		virus.position = $Enemy_Gun.get_global_position()
		get_tree().get_root().add_child(virus)
		queue_free()

func flip_sprite_to_player():
	if current_hp > 0:
		if player.position < position:
			$AnimatedSprite.flip_h = true
			$Weapon/Flame.position.x = -70
		if player.position > position:
			$AnimatedSprite.flip_h = false
			$Weapon/Flame.position.x = 0

func _on_Sight_body_entered(body):
	if body == player:
		player_in_range = true

func _idle():
	pass

func _on_Sight_body_exited(body):
	if body == player:
		player_in_range = false


func SightCheck():
	if player_in_range == true:
		var space_state = get_world_2d().direct_space_state
		var sight_check = space_state.intersect_ray(position, player.position, [self], collision_mask)
		if sight_check:
			if sight_check.collider.name == "Player":
				player_in_sight = true
				player_position = player.get_global_position()
				$EnemyFSM.call_deferred("set_state", $EnemyFSM.states.george_attack)
			if sight_check.collider.name != "Player":
				player_in_sight = false
	else:
		if current_hp > 0:
			$EnemyFSM.call_deferred("set_state", $EnemyFSM.states.george_chase)
		stop_flame()
