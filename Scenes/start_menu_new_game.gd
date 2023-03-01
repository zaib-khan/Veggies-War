extends "res://Scripts/Pause_menu_button.gd"



func _on_Start_menu_new_game_pressed():
	PlayerGameSaver.delete_saved_data()
	SceneChanger.change_scene(PlayerGameSaver.get_world())

