extends KinematicBody2D

var random_ammo = load("res://Scripts/random_ammo_generator.gd").new()
var random_heart = load("res://Scripts/random_heart_generator.gd").new()
var gravity = 10
var speed = 100
var UP = Vector2(0,-1)
var motion = Vector2()
var direction = 1
var dead = false
var damage = 30

#health
signal health_updated(new_health)
export (float) var max_health = 100
onready var health = max_health setget set_health





func _physics_process(delta):
	if not dead:
		motion.y += gravity
		motion.x = speed*direction
		$AnimatedSprite.play("walking")
		change_direction_sprite()
		player_collision_check()
		
		motion = move_and_slide(motion,UP)
		
		if is_on_wall() or $RayCast2D.is_colliding() == false:
			direction = direction*-1
			$RayCast2D.position.x *= -1

func player_collision_check():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "Player" and !collision.collider.get_collided_with_enemy():
			collision.collider.toggle_collided_with_enemy()
			collision.collider.damage_taken(get_damage())
			collision.collider.damage_taken_movement(direction*-1)


func get_max_health():
	return max_health

func get_direction():
	return direction


func get_damage():
	return damage

func change_direction_sprite():
	if direction == 1:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false

func _on_Timer_timeout():
	queue_free()


#--------------------------- HEALTH

func damage_taken(amount):
	if not $Damage_taken.playing:
		$Damage_taken.play()
	$AnimationPlayer.play("damage_income")
	$Life_bar.visible = true
	$Life_bar_visibility_timer.start()
	set_health(health - amount)

func kill():
	$Life_bar.visible = false
	call_deferred("heart_drop")
	call_deferred("drop_ammo")
	dead = true
	motion.x = 0
	$AnimatedSprite.play("dead")
	$CollisionShape2D.set_deferred("disabled",true)
	$Timer.start()

func set_health(value):
	var prev_health = health
	health = clamp(value,0,max_health)
	if health != prev_health:
		emit_signal("health_updated",health)
		if health == 0:
			kill()
		

func _exit_tree():
	random_ammo.free()
	random_heart.free()

func heart_drop():
	var t = random_heart.get_heart()
	if t != null:
		t = t.instance()
		get_parent().add_child(t)
		t.position = position
		t.lunch()

func drop_ammo():
	var t = random_ammo.get_random_ammo().instance()
	get_parent().add_child(t)
	t.position = position
	t.lunch()
