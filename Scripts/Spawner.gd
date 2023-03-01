extends Area2D


func _ready():
	pass


func _on_Spawner_body_entered(body):
	PlayerGameSaver.set_last_spawner_position(position)
	PlayerGameSaver.set_last_spawner_pv(PlayerGlobalData.get_health())
	PlayerGameSaver.set_weapon_name_list()
	PlayerGameSaver.set_weapon_ammo_amount_list()
