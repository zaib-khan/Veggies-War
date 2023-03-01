extends Area2D

const speed = 350
var motion = Vector2()
var direction = 1
var damage = 30

func _ready():
	$Shoot_sound.play()

func _physics_process(delta):
	$AnimatedSprite.play("glowing")
	
	motion.x = speed*delta*direction
	
	translate(motion)
	

func set_arrow_direction(dir):
	direction = dir
	if dir == -1:
		$AnimatedSprite.flip_h = true

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Area2D_body_entered(body):
	if "Enemy" in body.name:
		body.damage_taken(damage)
