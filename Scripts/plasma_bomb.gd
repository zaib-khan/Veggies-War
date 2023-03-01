extends RigidBody2D

export var exploded = false

var direction = 1
const print_name = "Plasma bomb"
var damage = 50




func lunch(pos):
	var vel = Vector2(500*direction,0)
	apply_impulse(pos,vel)


func get_print_name():
	return print_name



func set_plasma_bomb_direction(dir):
	direction = dir




func _on_Timer_timeout():
	$AnimationPlayer.play("explode")
	$explosion_sound.play()
	yield($explosion_sound,"finished")
	queue_free()




func _on_RigidBody2D_body_entered(body):
	if body.has_method("damage_taken"):
		body.damage_taken(damage)


func _on_Area2D_body_entered(body):
	if body.has_method("damage_taken"):
		body.damage_taken(damage)
