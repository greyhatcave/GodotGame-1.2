extends Camera2D

const LOOK_AHEAD_FACTOR = 0.050
const SHIFT_TRANS = Tween.TRANS_SINE
const SHIFT_EASE = Tween.EASE_OUT
const SHIFT_DURATION = 1.0

var facing = 0
var parent = get_parent()

onready var prev_camera_pos = get_camera_position()
onready var tween = $ShiftTween
onready var player = get_node("/root/Level01/Player")

func _process(_delta):
	_check_facing()
	prev_camera_pos = get_camera_position()
	
	#Test for camera position
	if player.position.y < 1009:
		drag_margin_v_enabled = true
		position.y = -508
	
	if player.position.y > 1009:
		drag_margin_v_enabled = true
		position.y = -85
		drag_margin_v_enabled = false


func _check_facing():
	var new_facing = sign(get_camera_position().x - prev_camera_pos.x)
	if new_facing != 0 && facing != new_facing:
		facing = new_facing
		var target_offset = get_viewport_rect().size.x * LOOK_AHEAD_FACTOR * facing
		
		tween.interpolate_property(self, "position:x", position.x, target_offset, SHIFT_DURATION, SHIFT_TRANS, SHIFT_EASE)
		tween.start()

#func _on_Player_grounded_updated(is_grounded):
	#drag_margin_v_enabled = !is_grounded
