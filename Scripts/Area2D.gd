extends Area2D


export(String, FILE, "*.tscn") var next_world
export(Vector2) var player_spawn_location = Vector2.ZERO

func _on_Area2D_body_entered(body):
	if body.name =="Player":
		PlayerGameSaver.set_new_world(next_world)
		
		SceneChanger.change_scene(next_world)
		PlayerGlobalData.player_current_position = player_spawn_location
