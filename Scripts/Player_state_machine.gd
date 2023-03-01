extends "res://State_machine.gd"

func _ready():
	add_state("stand_by")
	add_state("run")
	add_state("jump")
	add_state("fall")
	add_state("dash")
	call_deferred("set_state",states_list.stand_by)


func state_logic(delta):
	pass

func get_transition(delta):
	return null

func enter_state(new_state, old_state):
	pass

func exit_state(old_state, new_state):
	pass
