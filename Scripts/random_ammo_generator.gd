extends Node

var rng  = RandomNumberGenerator.new()

var blue_ammo = load("res://Scenes/Blue_ammo.tscn")
var red_ammo = load("res://Scenes/Red_ammo.tscn")
var green_ammo = load("res://Scenes/Green_ammo.tscn")

func get_random_number():
	rng.randomize()
	rng.randomize()
	rng.randomize()
	return int(rng.randf_range(1,100))


func get_random_ammo():
	var res = red_ammo
	var rand = get_random_number()
	
	if rand < 50 and rand >= 30:
		res = blue_ammo
	elif rand < 30:
		res = green_ammo
	
	return res










