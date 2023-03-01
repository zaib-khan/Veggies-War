extends Area2D

const speed = 450
var motion = Vector2()
var direction = 1
var can_move = true
var damage = 20
var fire_rate = 0.6
const print_name = "Fire ball"

func _ready():
	$laser_shoot_sound.play()



func _physics_process(delta):
	if can_move:
		motion.x = speed*delta*direction
		$AnimatedSprite.play("fire")
	else:
		motion.x = 0
		$AnimatedSprite.play("collision_explision")
	
	
	translate(motion)
	

func get_print_name():
	return print_name

func get_get_fire_rate():
	return fire_rate

func get_fire_ball_damage():
	return damage

func set_fire_ball_direction(dir):
	direction = dir
	if dir == -1:
		$AnimatedSprite.flip_h = true


func out_of_screen():
	queue_free()


func _on_fire_ball_body_entered(body):
	$Trail.emitting = false
	$Explosion.emitting = true
	can_move = false
	if "Enemy" in body.name:
		body.damage_taken(damage)
	
	


func _on_AnimatedSprite_animation_finished():
	if !can_move :
		queue_free()

