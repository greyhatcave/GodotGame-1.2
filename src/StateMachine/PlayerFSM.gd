extends StateMachine

const STOP_THRESHOLD = 32.0

var cursor_image = load("res://assets/png/cross_new.png")

func _ready():
	Input.set_custom_mouse_cursor(cursor_image,
			Input.CURSOR_ARROW,
			Vector2(14, 14))
			
	if parent.player_alive:
		add_state("idle")
		add_state("run")
		add_state("jump")
		add_state("fall")
		add_state("crouch")
		add_state("crawl")
		call_deferred("set_state", states.idle)

func _input(event):
	if event.is_action_pressed("jump"):
		if [states.idle, states.run].has(state) \
				|| ([states.crouch, states.crawl].has(state) && parent.can_stand()):
					parent.velocity.y = parent.jump_velocity
			
func _state_logic(delta):
	if [states.idle, states.run, states.jump, states.fall].has(state):
		parent._handle_move_input()
	elif [states.crouch, states.crawl].has(state):
		parent._handle_move_input(parent.CRAWL_SPEED)
	parent._apply_gravity(delta)
	parent._apply_movement()

func _get_transition(_delta):
	if parent.player_alive:
		match state:
			states.idle:
				if !parent.is_grounded:
					if parent.velocity.y < 0:
						return states.jump
					elif parent.velocity.y >= 0:
						return states.fall
				elif parent.velocity.x != 0:
					return states.run
				elif Input.is_action_pressed("crouch"):
					return states.crouch
			states.run:
				if !parent.is_grounded:
					if parent.velocity.y < 0:
						return states.jump
					elif parent.velocity.y >= 0:
						return states.fall
				elif parent.velocity.x == 0:
					return states.idle
				elif Input.is_action_pressed("crouch"):
					return states.crawl
			states.jump:
				if parent.is_grounded:
					return states.idle
				elif parent.velocity.y >= 0:
					return states.fall
			states.fall:
				if parent.is_grounded:
					return states.idle
				elif parent.velocity.y < 0:
					return states.jump
			states.crouch:
				if !Input.is_action_pressed("crouch"): #&& parent.can_stand():
					return states.idle
				elif !parent.is_grounded:
					if parent.velocity.y < 0:
						return states.jump
					else:
						return states.fall
				elif abs(parent.velocity.x) >= STOP_THRESHOLD:
					return states.crawl
			states.crawl:
				if !Input.is_action_pressed("crouch"): #&& parent.can_stand():
					return states.run
				elif !parent.is_grounded:
					if parent.velocity.y < 0:
						return states.jump
					else:
						return states.fall
				elif abs(parent.velocity.x) >= STOP_THRESHOLD:
					return states.crouch
					
		return null

func _enter_state(new_state, _old_state):
	if parent.player_alive:
		match new_state:
			states.idle:
				parent.anim_player.play("idle_new")
			states.run:
				parent.anim_player.play("run_new")
			states.jump:
				parent.anim_player.play("jump_new")
			states.fall:
				pass #parent.anim_player.play("fall")
			states.crouch:
				parent.anim_player.play("crouch_new")
				if _old_state != states.crawl:
					parent._on_crouch()
			states.crawl:
				pass #parent.anim_player.play("crawl_new")
				#if old_state != states.crouch:
					#parent._on_crouch()

func _exit_state(old_state, new_state):
	match old_state:
		states.crouch:
			if new_state != states.crawl:
				parent._on_stand()
		states.crawl:
			if new_state != states.crouch:
				parent._on_stand()

func is_crouched():
	return [states.crouch, states.crawl].has(state)
