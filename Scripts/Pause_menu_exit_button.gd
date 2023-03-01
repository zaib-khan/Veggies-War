extends "res://Scripts/Pause_menu_button.gd"


func _ready():
	pass


func _on_Exit_button_pressed():
	get_parent().get_parent().visible = false
	get_tree().paused = false
	SceneChanger.change_scene("res://Scenes/Main_Menu.tscn")
	#get_tree().change_scene("res://Scenes/Main_Menu.tscn")
	
