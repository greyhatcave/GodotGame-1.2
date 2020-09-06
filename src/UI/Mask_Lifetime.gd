extends Control


const BAR_SPEED = 5

var current_bar_value = 100

onready var mask_bar = get_tree().get_root().get_node("Level01").get_node("UI/Mask_Lifetime/Mask_Lifetime")

func _process(delta):
	drain_while_pressed(delta)
#	current_bar_value -= BAR_SPEED * delta
#
#	current_bar_value = max(current_bar_value, 0)
#
#	mask_bar.value = current_bar_value


func drain_while_pressed(delta):
	if Input.is_action_pressed("crouch"):
		current_bar_value -= BAR_SPEED * delta
	
		current_bar_value = max(current_bar_value, 0)
	
		mask_bar.value = current_bar_value
		
