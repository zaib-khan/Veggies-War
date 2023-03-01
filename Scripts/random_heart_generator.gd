extends Node

var rng  = RandomNumberGenerator.new()
var heart = load("res://Scenes/heart.tscn")
func _ready():
	pass

func get_random_number():
	rng.randomize()
	return int(rng.randf_range(0,100))





func get_heart():
	var res = null
	if get_random_number() >= 40:
		res = heart
	return res
	







