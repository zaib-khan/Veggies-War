extends TextureRect

func _ready():
	texture = PlayerGlobalData.get_current_weapon().get_image()


func _on_Player_weapon_changed(new_weapon):
	texture = new_weapon.get_image()
