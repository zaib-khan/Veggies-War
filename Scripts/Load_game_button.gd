extends Button
onready var click = get_parent().get_parent().get_node("Click")

func _ready():
	disabled = !PlayerGameSaver.data_exist()


func _on_Load_Game_pressed():
	click.play()
	PlayerGameSaver.test_load()
	SceneChanger.change_scene(PlayerGameSaver.get_world())
