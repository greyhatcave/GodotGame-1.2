extends Control


const BAR_SPEED = 20
const DRAIN_SPEED = 4
const SCORE_SPEED = 1

var current_bar_value = 100

onready var mask_bar = get_tree().get_root().get_node("Level01").get_node("UI/Mask_Lifetime/Mask_Lifetime")


func _process(delta):
	fill_while_pressed(delta)
	drain_loop(delta)


func fill_while_pressed(delta):
	if Globals.points >= 1:
		if Input.is_action_pressed("crouch"):
			current_bar_value += BAR_SPEED * delta
			Globals.points -= SCORE_SPEED
			current_bar_value = min(current_bar_value, 100)
		
			mask_bar.value = current_bar_value
		
func drain_loop(delta):
	current_bar_value -= DRAIN_SPEED * delta
	current_bar_value = max(current_bar_value, 0)
	mask_bar.value = current_bar_value
	
