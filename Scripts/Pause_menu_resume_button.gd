extends "res://Scripts/Pause_menu_button.gd"



func _on_Resume_button_pressed():
	get_parent().get_parent().visible = false
	get_tree().paused = false
