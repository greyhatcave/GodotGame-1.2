extends KinematicBody2D
class_name Enemies


var max_hp = 3
var current_hp
var floating_text = preload("res://src/UI/FloatingText.tscn")
onready var standing_collision = $CollisionShape2D

func _ready():
	current_hp = max_hp

func OnHit(damage):
	current_hp -= damage
	get_node("HealthBar").value = int((float(current_hp) / max_hp) * 100)
	var text = floating_text.instance()
	text.amount = damage
	add_child(text)
	if current_hp <= 0:
		$HealthBar.hide()
		standing_collision.set_deferred("disabled",true)
