extends RigidBody2D

var player = load("res://Scripts/Player.gd")
var rng  = RandomNumberGenerator.new()


func _ready():
	$AnimatedSprite.play("glow")
	$Timer.start()



func lunch():
	var vel = Vector2(-50,-200)
	apply_impulse(position,vel)

func get_random_number():
	rng.randomize()
	return int(rng.randf_range(3,7))







func _on_Timer_timeout():
	queue_free()


func _on_Green_ammo_body_entered(body):
	if body is player:
		body.add_ammo_to_weapon(load("res://Scripts/Green_ammo.gd"),get_random_number())
		queue_free()
	
