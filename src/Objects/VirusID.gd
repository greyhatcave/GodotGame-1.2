extends Area2D

var current_coins
var coin_value = 1

var move = Vector2.ZERO
var look_vec = Vector2.ZERO
var speed = 9
var vid_in_touch = false
var player_in_range_of_coin


onready var sprite = $Sprite


onready var timer = $Timer
onready var player = get_parent().get_node("Level01/Player")
onready var vid_ui = get_parent().get_node("Level01/UI/Inventory/VirusID_Score/Panel")
onready var vid_amount = get_parent().get_node("Level01/UI/Inventory/VirusID_Score/Panel/Amount")
onready var vid_position = get_parent().get_node("Level01/UI/Inventory/VirusID_Score/Panel/TextureRect")


func _ready():
	look_vec = vid_position.get_global_position() - global_position
	current_coins = coin_value
	$AnimationPlayer.play("Bounce")



func _physics_process(delta):
	coins_to_player(delta)



func _on_VirusID_body_entered(body):
	if body.is_in_group("Player"):
		vid_in_touch = true
		vid_ui.show()
		body.AddCoin(coin_value)
		timer.start()
		queue_free()

func coins_to_player(delta):
	if player_in_range_of_coin:
		if player:
			look_vec = player.position - global_position
			move = move.move_toward(look_vec, delta)
			move = move.normalized() * speed
			position += move

func _on_Sight_body_entered(body):
	if body == player:
		player_in_range_of_coin = true


##Hello!
