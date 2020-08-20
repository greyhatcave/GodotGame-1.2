extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _process(delta):
	$Panel/Amount.text = str(Globals.total_coin)
	#get_node("VirusID_Score/Panel/Amount").text = str(total_coin)
