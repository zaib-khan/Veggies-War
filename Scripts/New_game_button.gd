extends Button

onready var click = get_parent().get_node("Click")




func _on_New_Game_pressed():
	click.play()
	PlayerGameSaver.delete_saved_data()
	SceneChanger.change_scene(PlayerGameSaver.get_world())
	
