extends RigidBody2D
var player = load("res://Scripts/Player.gd")
var rng  = RandomNumberGenerator.new()

func _ready():
	$AnimatedSprite.play("glow")
	$Timer.start()


func lunch():
	var vel = Vector2(50,-200)
	apply_impulse(position,vel)


func get_random_number():
	rng.randomize()
	return int(rng.randf_range(20,50))


func _on_heart_body_entered(body):
	if body is player:
		body.add_health(get_random_number())
		queue_free()


func _on_Timer_timeout():
	queue_free()
