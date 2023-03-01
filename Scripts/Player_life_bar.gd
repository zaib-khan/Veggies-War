extends TextureProgress

#export var player_node_path : NodePath

func _ready():
	value = PlayerGlobalData.get_health()

func _on_Player_health_updated(new_health):
	value = new_health
