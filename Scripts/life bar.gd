extends TextureProgress

func _ready():
	value = get_parent().get_max_health()
	visible = false
	
	


func _on_Enemy_health_updated(new_health):
	value = new_health


func _on_Life_bar_visibility_timer_timeout():
	visible = false
