extends Node

class_name State_machine

var state = null
var previous_state = null
var states_list = {}

onready var parent_node = get_parent()

func _physics_process(delta):
	if state != null : 
		state_logic(delta)
		var transition = get_transition(delta)
		if transition != null : 
			set_state(transition)


func state_logic(delta):
	pass

func get_transition(delta):
	return null

func enter_state(new_state, old_state):
	pass

func exit_state(old_state, new_state):
	pass

func set_state(new_state):
	previous_state = state
	state = new_state
	
	if previous_state != null :
		exit_state(previous_state,new_state)
	if new_state != null : 
		enter_state(new_state,previous_state)

func add_state(state_name):
	states_list[state_name] = states_list.size()

