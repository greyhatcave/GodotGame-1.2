extends Actor


const FLOOR_NORMAL: = Vector2.UP

var can_fire = true

var player_position

onready var anim_player = $AnimatedSprite

onready var player = get_parent().get_node("Player")
onready var enemy = get_parent().get_node("Enemy")

export var speed: = Vector2(200.0, 1000.0)
export var gravity: = 3000.0

var player_in_range
var player_in_sight

var _velocity: = Vector2.ZERO
var max_hp = 3
var current_hp

onready var parent = get_parent()

onready var standing_collision = $CollisionShape2D
onready var BULLET_SCENE = preload("res://src/Objects/EnemyBullet.tscn")
onready var VIRUS_ID = preload("res://src/Objects/VirusID.tscn")


func _ready() -> void:
	_velocity.x = -speed.x
	current_hp = max_hp
	$EnemyFSM.call_deferred("set_state", $EnemyFSM.states.chase)
	

func _apply_gravity(delta):
	_velocity.y += gravity * delta

func _walk():
	if is_on_wall():
		_velocity.x *= -1.0
	if current_hp >= 1:
		_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y
	if _velocity.x <= -1.0:
		$AnimatedSprite.flip_h = true
	elif _velocity.x > 0:
		$AnimatedSprite.flip_h = false


func _idle():
	pass
	###

func OnHit(damage):
	current_hp -= damage
	get_node("HealthBar").value = int((float(current_hp) / max_hp) * 100)
	if current_hp <= 0:
		$AnimatedSprite.play("enemy_dead")
		$HealthBar.hide()
		standing_collision.set_deferred("disabled",true)


func fire():
	if player_in_sight && current_hp > 0:
		can_fire = false
		var bullet = BULLET_SCENE.instance()
		bullet.position = $Enemy_Gun/Gun_FirePointer.get_global_position()
		bullet.player = player
		get_tree().get_root().add_child(bullet)
		yield(get_tree().create_timer(0.5), "timeout")
		can_fire = true

func _physics_process(_delta):
	SightCheck()
	

func _on_AnimatedSprite_animation_finished():
	if current_hp <= 0:
		var virus = VIRUS_ID.instance()
		virus.position = $Enemy_Gun.get_global_position()
		get_tree().get_root().add_child(virus)
		queue_free()


func _on_Sight_body_entered(body):
	if body == player:
		player_in_range = true


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
				$EnemyFSM.call_deferred("set_state", $EnemyFSM.states.attack)
			else:
				player_in_sight = false
				$EnemyFSM.call_deferred("set_state", $EnemyFSM.states.chase)
	else:
		$EnemyFSM.call_deferred("set_state", $EnemyFSM.states.chase)
