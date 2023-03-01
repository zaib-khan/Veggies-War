extends Node

var weapon_name
var coolDown
var image
var ammoAmount
var maxAmmo
var weapon_scene
var mask_number
var ammo_type

func _init(weapon_name,coolDown,image,ammoAmount,maxAmmo,weapon_scene,mask_number,ammo_type):
	self.weapon_name = weapon_name
	self.coolDown = coolDown
	self.ammoAmount = ammoAmount
	self.maxAmmo = maxAmmo
	self.mask_number = mask_number
	
	
	self.image = image
	self.weapon_scene = weapon_scene
	self.ammo_type = ammo_type



func get_weaponName():
	return weapon_name

func get_coolDown():
	return coolDown

func get_image():
	return image

func get_ammoAmount():
	return ammoAmount

func get_maxAmmo():
	return maxAmmo

func get_weapon_scene():
	return weapon_scene

func get_mask_number():
	return self.mask_number

func get_ammo_type():
	return self.ammo_type

func has_ammo():
	var res = false
	if get_ammoAmount() > 0:
		res = true
	return res


func set_ammoMinus_1():
	if 0 >self.ammoAmount-1:
		self.ammoAmount = 0
	else:
		self.ammoAmount = self.ammoAmount-1


func is_ammo_full():
	return self.ammoAmount == self.maxAmmo

func add_ammo(value):
	if self.ammoAmount+value > get_maxAmmo():
		self.ammoAmount = get_maxAmmo()
	else:
		self.ammoAmount = self.ammoAmount+value

func set_loaded_ammo(new_ammo):
	self.ammoAmount = new_ammo





