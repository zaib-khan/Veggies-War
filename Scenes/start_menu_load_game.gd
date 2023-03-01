extends "res://Scripts/Pause_menu_button.gd"


func _ready():
	disabled = !PlayerGameSaver.data_exist()






func _on_Start_menu_load_game_pressed():
	PlayerGameSaver.test_load()
	SceneChanger.change_scene(PlayerGameSaver.get_world())
