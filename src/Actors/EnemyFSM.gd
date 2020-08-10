extends StateMachine


func _ready():
	add_state("idle")
	add_state("chase")
	add_state("attack")
	add_state("dead")
	
	add_state("george_idle")
	add_state("george_chase")
	add_state("george_attack")
	add_state("george_dead")


func _state_logic(delta):
	parent._apply_gravity(delta)

func _get_transition(_delta):
	if state == states.idle:
		parent._idle()
	if state == states.george_idle:
		parent._idle()
	
	if state == states.chase:
		parent._walk()
	if state == states.george_chase:
		parent._walk()
		
	if state == states.attack:
		if parent.can_fire == true:
			parent.fire()
		if parent.current_hp <= 0:
			return states.dead
		else:
			return states.idle

	if state == states.george_attack:
		parent._walk()
		parent.fire()
		if parent.current_hp <= 0:
			return states.george_dead
		else:
			return states.george_chase
			
	if state == states.dead:
		return states.dead#$EnemyFSM.call_deferred("set_state", $EnemyFSM.states.dead)
		
func _enter_state(_new_state, _old_state):
	match _new_state:
		states.idle:
			parent.anim_player.play("enemy_idle")
		states.george_idle:
			parent.anim_player.play("george_idle")
		states.attack:
			pass
		states.george_attack:
			parent.anim_player.play("george_idle")
		states.chase:
			parent.anim_player.play("enemy_run")
		states.george_chase:
			parent.anim_player.play("george_chase")
		states.dead:
			parent.anim_player.play("enemy_dead")
		states.george_dead:
			parent.anim_player.play("george_dead")

func _exit_state(_old_state, _new_state):
	pass
