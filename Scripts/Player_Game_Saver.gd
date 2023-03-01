extends Node

const SAVE_DIR = "user://saves/"
const FILE_NAME = "save.dat"
var save_path = SAVE_DIR+FILE_NAME
const LOKEY = "je suis de mons 7000"

#------------ KEYS NAMES
const LAST_POS = "last_position"
const PV = "health"
const WEAPON = "weapon_list"
const WEAPON_AMMO = "weapon_ammo_list"
const WORLD = "last_world"



var data = {
	PV : PlayerGlobalData.MAX_HEALTH,
	LAST_POS : PlayerGlobalData.player_current_position,
	WEAPON : [],
	WEAPON_AMMO : [],
	WORLD : "res://Scenes/World.tscn"
}

var test


#func _notification(what):
#	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
#		test_save()
#
#		print(get_filename())
#
#


#func _ready():
#	test_load()
#	exe()


func test_save():
	
	var dir = Directory.new()
	if not dir.dir_exists(SAVE_DIR):
		dir.make_dir(SAVE_DIR)
	
	var file = File.new()
	var error = file.open_encrypted_with_pass(save_path,File.WRITE,LOKEY)
	if error == OK:
		file.store_var(data)
		file.close()
		print("SAVE OK")
	else:
		print("Erreur lors de la lecture du fichier ")



func test_load():
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open_encrypted_with_pass(save_path,File.READ,LOKEY)
		if error == OK:
			test = file.get_var()
			if test.has_all(data.keys()):
				PlayerGlobalData.player_current_position = test[LAST_POS]
				PlayerGlobalData.set_health(test[PV])
				data[WORLD] = test[WORLD]
				#add_weapons()
				set_ammo()
			file.close()

#------------------------------------------------------ SETTERS

func set_last_spawner_position(pos):
	if data[LAST_POS] != pos :
		data[LAST_POS] = pos

func set_last_spawner_pv(health):
	if data[PV] != health :
		data[PV] = health

func set_weapon_name_list():
	if data[WEAPON].size() != PlayerGlobalData.get_weapon_name_list().size():
		data[WEAPON].clear()
		data[WEAPON] = PlayerGlobalData.get_weapon_name_list()

func set_weapon_ammo_amount_list():
	if data[WEAPON_AMMO].size() != PlayerGlobalData.get_weapon_ammoAmount_list().size():
		data[WEAPON_AMMO].clear()
		data[WEAPON_AMMO] = PlayerGlobalData.get_weapon_ammoAmount_list()
	else:
		var i = 0
		var list  = PlayerGlobalData.get_weapon_ammoAmount_list()
		
		while(i < list.size()):
			
			if list[i] != data[WEAPON_AMMO][i]:
				data[WEAPON_AMMO][i] = list[i]
			i = i+1

func set_new_world(new_world):
	data[WORLD] = new_world




#------------------------------------------------------ GETTERS

func get_world():
	return data[WORLD]










func add_weapons():
	for w in test[WEAPON]:
		PlayerGlobalData.add_weapon(PlayerGlobalData.find_weapon_by_name(w))
func set_ammo():
	var i = 0
	
	while(i < test[WEAPON_AMMO].size()):
		PlayerGlobalData.set_ammo(i,test[WEAPON_AMMO][i])
		i = i+1

func exe():
	print(test)

func data_exist():
	var file = File.new()
	return file.file_exists(save_path)

func delete_saved_data():
	var dir = Directory.new()
	if dir.dir_exists(SAVE_DIR) and dir.file_exists(save_path):
		if dir.remove(save_path) == OK:
			print("FILE DELETED")


#var dir = Directory.new()
#dir.remove("user://savegame.save")

