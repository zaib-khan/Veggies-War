extends CanvasLayer

const FRONT = 2
const BACK = -100


signal scene_changed()




onready var animation_player = $Scene_changer_animation_player
onready var black = $Control/ColorRect

func change_scene(path):
	var scene_name = get_tree().get_current_scene().get_name()
	var music = get_tree().get_root().get_node(scene_name+"/Background_music_player")
	layer = FRONT
	music.play_fade_out()
	animation_player.play("fade_to_black")
	yield(animation_player,"animation_finished")
	get_tree().change_scene(path)
	emit_signal("scene_changed")
	animation_player.play("fade_out_of_black")
	yield(animation_player,"animation_finished")
	layer = BACK








