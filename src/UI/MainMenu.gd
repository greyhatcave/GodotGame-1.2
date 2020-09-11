extends Node2D


func _on_PlayButton_pressed():
	get_tree().change_scene("res://src/Levels/LevelTemplate.tscn")


func _on_ExitButton_pressed():
	get_tree().quit()
