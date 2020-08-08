extends Actor

const GRAVITY = 3000
const SPEED = 50
const FLOOR = Vector2(0, -1)

var velocity = Vector2()
var direction = 1
var max_hp = 3
var current_hp
var player_in_range
var player_in_sight
var player_position

var can_fire = true


onready var standing_collision = $CollisionShape2D
onready var BULLET_SCENE = preload("res://src/Objects/EnemyBullet.tscn")
onready var VIRUS_ID = preload("res://src/Objects/VirusID.tscn")
onready var player = get_parent().get_node("Player")
onready var anim_player = $AnimatedSprite


func _ready():
	current_hp = max_hp
	$EnemyFSM.call_deferred("set_state", $EnemyFSM.states.chase)


func _physics_process(delta):
	flip_sprite_to_player()
	SightCheck()

func _apply_gravity(delta):
	velocity.y += GRAVITY * delta

func _walk():
	if current_hp > 1:
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

func _on_AnimatedSprite_animation_finished():
	if current_hp <= 0:
		var virus = VIRUS_ID.instance()
		virus.position = $Enemy_Gun.get_global_position()
		get_tree().get_root().add_child(virus)
		queue_free()

func flip_sprite_to_player():
	if player.position < position:
		$AnimatedSprite.flip_h = true
	if player.position > position:
		$AnimatedSprite.flip_h = false

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
