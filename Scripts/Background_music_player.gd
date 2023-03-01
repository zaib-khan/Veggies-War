extends AudioStreamPlayer

onready var animation_player = $AnimationPlayer

func _ready():
	play_fade_in()


func play_fade_out():
	animation_player.play("fade_out")

func play_fade_in():
	animation_player.play("fade_in")








