extends Node

const MAX_HEALTH = 100
var current_health = MAX_HEALTH
var is_health_needed_to_get_full = false

var weapon_class = load("res://Scripts/Weapon.gd")
var fireBall = weapon_class.new("Fire Ball",0.4,load("res://Sprites/fire_ball_test/fire_ball_test_2.png"),20,20,preload("res://Scenes/fire_ball.tscn"),5,load("res://Scripts/fire_ball.gd"))
var plasmaBomb = weapon_class.new("Plasma Bomb",1,load("res://Sprites/plasma_bomb/plasma_bomb_1.png"),10,10,preload("res://Scenes/plasma_bomb.tscn"),6,load("res://Scripts/Blue_ammo.gd"))
var arrow = weapon_class.new("Laser Arrow",0.6,load("res://Sprites/arrow/arrow1.png"),15,15,preload("res://Scenes/Arrow.tscn"),4,load("res://Scripts/Green_ammo.gd"))
var current_weapon = 0
var weapon_list = []
var all_weapon_list = []

var player_current_position = Vector2(96,288)


func _ready():
	all_weapon_list.append(fireBall)
	all_weapon_list.append(plasmaBomb)
	all_weapon_list.append(arrow)
	
	

	weapon_list.append(fireBall)
	weapon_list.append(plasmaBomb)
	weapon_list.append(arrow)

#------------------------------------------------HEALTH

func get_max_health():
	return MAX_HEALTH

func get_current_health():
	return current_health

func set_health(new_health):
	current_health = new_health

func health_refill():
	current_health = get_max_health()
	is_health_needed_to_get_full = false

func need_health_refill():
	is_health_needed_to_get_full = true

func get_health():
	if is_health_needed_to_get_full:
		health_refill()
	
	return get_current_health()


func _exit_tree():
	fireBall.free()
	plasmaBomb.free()
	arrow.free()
	weapon_list.clear()

#-----------------------------------------------------WEAPON
func get_current_weapon():
	return weapon_list[current_weapon]

func get_weapon_name_list():
	var list = []
	for w in weapon_list:
		list.append(w.get_weaponName())
	return list

func get_weapon_ammoAmount_list():
	var list = []
	for w in weapon_list:
		list.append(w.get_ammoAmount())
	return list

func find_weapon_by_name(weapon_name):
	var res = null
	
	for w in all_weapon_list:
		if weapon_name == w.get_weaponName():
			res = w
	
	return res

func add_weapon(w):
	if !weapon_list.has(w):
		weapon_list.append(w)
func set_ammo(index,amount):
	weapon_list[index].set_loaded_ammo(amount)





