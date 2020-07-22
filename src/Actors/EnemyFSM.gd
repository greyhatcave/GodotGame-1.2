extends StateMachine


func _ready():
	add_state("idle")
	add_state("chase")
	add_state("attack")
	add_state("dead")


func _state_logic(delta):
	parent._apply_gravity(delta)

func _get_transition(_delta):
	if state == states.idle:
		parent._idle()
	
	if state == states.chase:
		parent._walk()
		
	if state == states.attack:
		parent._walk()
		if parent.player_in_sight and parent.can_fire == true:
			parent.fire()
		if parent.current_hp <= 0:
			return states.dead
		else:
			return states.chase
			
	if state == states.dead:
		pass
		
func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			parent.anim_player.play("enemy_idle")
		states.attack:
			pass
		states.chase:
			parent.anim_player.play("enemy_run")
		states.dead:
			parent.anim_player.play("enemy_dead")

func _exit_state(old_state, new_state):
	pass
