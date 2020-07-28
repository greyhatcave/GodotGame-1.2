extends Panel

var EmptyInvItem = preload("res://src/UI/InvItem.tscn").instance()

var MaxInvSpace = 50

func _ready():
	for _i in range(MaxInvSpace):
		var NewInvItem = EmptyInvItem.duplicate()
		$ScrollContainer/GridContainer.add_child(NewInvItem)
		
		

func _input(_event):
	var open_inv = Input.is_action_just_pressed("inventory")
	var close_inv = Input.is_action_just_released("inventory")
	
	if open_inv:
		show()
	elif close_inv:
		hide()
