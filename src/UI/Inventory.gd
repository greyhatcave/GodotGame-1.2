extends Panel

var EmptyInvItem = preload("res://src/UI/InvItem.tscn").instance()

var MaxInvSpace = 50

func _ready():
	for _i in range(MaxInvSpace):
		var NewInvItem = EmptyInvItem.duplicate()
		$ScrollContainer/GridContainer.add_child(NewInvItem)

func _input(_event):
	if not visible:
		if Input.is_action_just_pressed("inventory"):
			show()
	elif visible:
		if Input.is_action_just_pressed("inventory"):
			hide()
