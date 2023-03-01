extends KinematicBody2D
const UP = Vector2(0,-1)
const _Enemy = preload("res://Scripts/Enemy.gd")
var dash_direction = Vector2(1,0)
var motion = Vector2()
onready var mouvement_animation = $Sprite
export var speed = 600
export var grav = 20
export var jump = -550
export var max_speed = 250
export var dash_speed = 500
export var dash_pause_timer = 1.1
var snap
var pos_y_prec = 0
var can_dash = false
var jumped = false
var is_dashing = false
var gravity_on = true
var friction = false
var is_stuck_to_wall = false
var can_move = true
var collided_with_enemy = false
var is_dead = false
var damage_income = false
var is_attacking = false
var is_on_platform = false
onready var timer_dash = get_node("Dash_Timer")

#HEALTH
signal health_updated(new_health)
signal killed()

onready var timer_invulnerability = $Invulnerability_Timer


#WEAPON


signal ammo_update(new_ammo_amount)
signal weapon_changed(new_weapon)








#STATE
var state

var states = {
	"STAND_BY" : 1,
	"RUN" : 2,
	"JUMP" : 3,
	"FALL" : 4,
	"DASH" : 5,
	"WALL_JUMP" : 6,
	"DEAD" :7,
	"DAMAGE_TAKEN" : 8,
	"ATTACK": 9,
}
var prev_state







func _ready():
	self.position = PlayerGlobalData.player_current_position
	change_state(states.STAND_BY)
	prev_state = states.STAND_BY
	timer_dash.set_wait_time(dash_pause_timer)
	
	
	emit_signal("ammo_update",PlayerGlobalData.get_current_weapon().get_ammoAmount())
	$Fire_rate_timer.wait_time = PlayerGlobalData.get_current_weapon().get_coolDown()
	
	auto_ammo_collision_check()
	heart_collision_check()
	


func _physics_process(delta):
	gravity()
	if not is_dead:
		if can_move:
			movement(delta)
		attack()
		dash()
		enemy_detection()
	else:
		motion.x = 0
	state_transition()
	snap = Vector2.DOWN * 32 if !jumped else Vector2.ZERO
	motion = move_and_slide_with_snap(motion,snap,UP)
#	print("prec : "+str(pos_y_prec))
#	print(" motion y : "+str(motion.y))
#	print("------")
	
#	print(Performance.get_monitor(Performance.MEMORY_STATIC))
#	print(Performance.get_monitor(Performance.TIME_FPS))

func _process(delta):
	if (Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left")) and motion.x != 0:
		if is_on_floor():
			if not $running_sound.playing:
				$running_sound.play()
	if Input.is_action_just_released("ui_right") or Input.is_action_just_released("ui_left") or motion.y != 0:
		$running_sound.stop()
	
	if state == states.WALL_JUMP and Input.is_action_just_pressed("ui_up"):
		$Wall_jump_sound.play()
	
	if state == states.WALL_JUMP:
		if !$Wall_sliding_sound.playing:
			$Wall_sliding_sound.play()
	elif state != states.WALL_JUMP:
		$Wall_sliding_sound.stop()
	
	if jumped :
		$jump_sound.play()
	
	if motion.y >= 0:
		if (pos_y_prec > motion.y and is_on_floor()) and !is_on_platform:
			$landing_sound.play()
		pos_y_prec = motion.y;
	






#--------------------------------- CUSTOM FUNCTIONS	

func speed_check():
	if not is_dashing :
		if motion.x > max_speed:
			motion.x = max_speed
		elif motion.x < -max_speed:
			motion.x = -max_speed

func gravity():
	if gravity_on:
		motion.y+= grav
	if colliding_wall() and motion.y > 100:
		motion.y = 70

func movement(delta):
	if not is_dashing:
		friction = false
		speed_check()
		if Input.is_action_pressed("ui_right"):
			if motion.x < max_speed :
				motion.x += speed*delta
			mouvement_animation.flip_h = false
			if sign($Position2D.position.x) == -1:
				$Position2D.position.x *= -1
				
		elif Input.is_action_pressed("ui_left"):
			if motion.x > -max_speed :
				motion.x -= speed*delta
				mouvement_animation.flip_h = true
			if sign($Position2D.position.x) == 1:
				$Position2D.position.x *= -1
		else:
			friction = true
		
		if is_on_floor():
			if Input.is_action_just_pressed("ui_up"):
				jumped = true
				motion.y = jump
			if friction:
				motion.x = lerp(motion.x,0,1)
		else:
			jumped = false
			
			wall_jump()
			
	#		if not friction:
	#			motion.x = lerp(motion.x,0,0.05)
		if Input.is_action_just_released("ui_up") and motion.y < 0:
			motion.y = motion.y + 200



func dash():
	if is_on_floor():
		can_dash = true
	
	if colliding_wall():
		can_dash = false
	elif prev_state == states.WALL_JUMP and state == states.JUMP :
		can_dash = true
	
	
	if Input.is_action_pressed("ui_right") or motion.x > 0:
		dash_direction = Vector2(1,0)
	if Input.is_action_pressed("ui_left") or motion.x < 0:
		dash_direction = Vector2(-1,0)
		
	if Input.is_action_just_pressed("dash") and can_dash and timer_dash.is_stopped():
		motion = dash_direction.normalized() * dash_speed
		is_dashing = true
		timer_dash.start()
		gravity_on = false
		$dash_sound.play()
		can_dash = false
		yield(get_tree().create_timer(0.3),"timeout")
		is_dashing = false
		gravity_on = true




#------------------------------ STATE MACHINE FUNCTION

func change_state(new_state):
	prev_state = state
	state = new_state
	match state:
		states.STAND_BY:
			mouvement_animation.play("stand_by_test")
		states.RUN:
			mouvement_animation.play("run_test")
		states.JUMP:
			mouvement_animation.play("jump_test")
		states.FALL:
			mouvement_animation.play("fall_test")
		states.DASH:
			mouvement_animation.play("dash")
		states.WALL_JUMP:
			mouvement_animation.play("wall_jump")
		states.DEAD:
			mouvement_animation.play("dead")
		states.DAMAGE_TAKEN:
			mouvement_animation.play("damage_taken")
		states.ATTACK:
			mouvement_animation.play("atk")

func state_transition():
	match state:
		states.STAND_BY:
			if !is_on_floor():
				if motion.y < 0:
					change_state(states.JUMP)
				elif motion.y > 0:
					change_state(states.FALL)
			elif damage_income:
				change_state(states.DAMAGE_TAKEN)
			elif !damage_income and is_attacking:
				change_state(states.ATTACK)
			elif is_dashing:
				change_state(states.DASH)
			elif motion.x != 0:
				change_state(states.RUN)
			elif is_dead:
				change_state(states.DEAD)
		states.RUN:
			if !is_on_floor():
				if motion.y < 0:
					change_state(states.JUMP)
				elif motion.y > 0:
					change_state(states.FALL)
			elif damage_income:
				change_state(states.DAMAGE_TAKEN)
			elif !damage_income and is_attacking:
				change_state(states.ATTACK)
			elif is_dashing:
				change_state(states.DASH)
			elif motion.x == 0:
				change_state(states.STAND_BY)
			elif is_dead:
				change_state(states.DEAD)
		states.JUMP:
			if is_on_floor():
				change_state(states.STAND_BY)
			elif damage_income:
				change_state(states.DAMAGE_TAKEN)
			elif !damage_income and is_attacking:
				change_state(states.ATTACK)
			elif colliding_wall():
				change_state(states.WALL_JUMP)
			elif is_dashing:
				change_state(states.DASH)
			elif motion.y >= 0:
				change_state(states.FALL)
			elif is_dead:
				change_state(states.DEAD)
		states.FALL:
			if is_on_floor():
				change_state(states.STAND_BY)
			elif damage_income:
				change_state(states.DAMAGE_TAKEN)
			elif !damage_income and is_attacking:
				change_state(states.ATTACK)
			elif colliding_wall():
				change_state(states.WALL_JUMP)
			elif is_dashing:
				change_state(states.DASH)
			elif motion.y < 0:
				change_state(states.JUMP)
			elif is_dead:
				change_state(states.DEAD)
		states.DASH:
			if is_on_floor():
				if not is_dashing:
					if motion.x == 0:
						change_state(states.STAND_BY)
					elif damage_income:
						change_state(states.DAMAGE_TAKEN)
					elif motion.x != 0:
						change_state(states.RUN)
					elif is_dead:
						change_state(states.DEAD)
			else:
				if not is_dashing:
					if motion.y < 0:
						change_state(states.JUMP)
					elif damage_income:
						change_state(states.DAMAGE_TAKEN)
					elif colliding_wall():
						change_state(states.WALL_JUMP)
					elif motion.y > 20:
						change_state(states.FALL)
					elif is_dead:
						change_state(states.DEAD)
		states.WALL_JUMP:
			if not is_on_floor():
				if not colliding_wall():
					if motion.y < 0:
						change_state(states.JUMP)
					elif damage_income:
						change_state(states.DAMAGE_TAKEN)
					elif motion.y > 0:
						change_state(states.FALL)
					elif is_dead:
						change_state(states.DEAD)
			else:
				if motion.x == 0:
					change_state(states.STAND_BY)
				elif damage_income:
					change_state(states.DAMAGE_TAKEN)
				elif motion.x != 0:
					change_state(states.RUN)
				elif is_dead:
					change_state(states.DEAD)
		states.DAMAGE_TAKEN:
			if !damage_income:
				if !is_on_floor():
					if motion.y < 0:
						change_state(states.JUMP)
					elif motion.y > 0:
						change_state(states.FALL)
				elif motion.x == 0:
					change_state(states.STAND_BY)
				elif is_dashing:
					change_state(states.DASH)
				elif motion.x != 0:
					change_state(states.RUN)
				elif is_dead:
					change_state(states.DEAD)
		states.ATTACK:
			if !is_attacking:
				if !is_on_floor():
					if motion.y < 0:
						change_state(states.JUMP)
					elif motion.y > 0:
						change_state(states.FALL)
				elif motion.x == 0:
					change_state(states.STAND_BY)
				elif is_dashing:
					change_state(states.DASH)
				elif motion.x != 0:
					change_state(states.RUN)
				elif is_dead:
					change_state(states.DEAD)


#------------------------- WALL JUMP 

func colliding_wall():
	return colliding_left_wall() or colliding_right_wall()

func colliding_right_wall():
	return $ray_right_up.is_colliding() and $ray_right_down.is_colliding()

func colliding_left_wall():
	return $ray_left_up.is_colliding() and $ray_left_down.is_colliding()

func wall_jump():
	
	if colliding_left_wall():
		mouvement_animation.flip_h = false
	elif colliding_right_wall():
		mouvement_animation.flip_h = true
	
	if colliding_left_wall() and Input.is_action_just_pressed("ui_up"):
		motion.x += 550
		motion.y += -700
		if sign($Position2D.position.x) == -1:
			$Position2D.position.x *= -1
	elif colliding_right_wall() and Input.is_action_just_pressed("ui_up"):
		motion.x += -550
		motion.y += -700
		if sign($Position2D.position.x) == 1:
			$Position2D.position.x *= -1

#---------------------------------------------- WEAPON MANAGEMENT
func add_new_weapon(new_weapon):
	PlayerGlobalData.weapon_list.append(new_weapon)

func change_weapon():
	if (PlayerGlobalData.current_weapon+1) == PlayerGlobalData.weapon_list.size():
		PlayerGlobalData.current_weapon = 0
	elif PlayerGlobalData.weapon_list[PlayerGlobalData.current_weapon+1] != null:
		PlayerGlobalData.current_weapon = PlayerGlobalData.current_weapon+1 
	emit_signal("weapon_changed",PlayerGlobalData.get_current_weapon())
	emit_signal("ammo_update",PlayerGlobalData.get_current_weapon().get_ammoAmount())

#-------------------------------------------------AMMO MANAGEMENT
func ammo_collision_check(c_w):
	if not get_collision_mask_bit(PlayerGlobalData.weapon_list[c_w].get_mask_number()):
		if not PlayerGlobalData.weapon_list[c_w].is_ammo_full():
			set_collision_mask_bit(PlayerGlobalData.weapon_list[c_w].get_mask_number(),true)
	else:
		if PlayerGlobalData.weapon_list[c_w].is_ammo_full():
			set_collision_mask_bit(PlayerGlobalData.weapon_list[c_w].get_mask_number(),false)

func auto_ammo_collision_check():
	var i = 0
	while(i < PlayerGlobalData.weapon_list.size()):
		ammo_collision_check(i)
		i = i+1



func add_ammo_to_weapon(ammo_type,amount):
	var index
	for w in PlayerGlobalData.weapon_list:
		if w.get_ammo_type() == ammo_type:
			w.add_ammo(amount)
			index = w
	if index == PlayerGlobalData.get_current_weapon():
		emit_signal("ammo_update",PlayerGlobalData.get_current_weapon().get_ammoAmount())
	ammo_collision_check(PlayerGlobalData.current_weapon)
	



#------------------------------------------ ATTACK
func attack():
	if Input.is_action_just_pressed("change_weapon"):
		change_weapon()
	
	
	if !colliding_wall():
		if $Fire_rate_timer.is_stopped():
			if Input.is_action_pressed("fire"):
				is_attacking = true
				$Fire_rate_timer.start()
				match PlayerGlobalData.current_weapon:
					0:
						fire_ball_attack()
					1:
						plasma_bomb_attack()
					2:
						arrow_attack()
				
				
				PlayerGlobalData.get_current_weapon().set_ammoMinus_1()
				ammo_collision_check(PlayerGlobalData.current_weapon)
				emit_signal("ammo_update",PlayerGlobalData.get_current_weapon().get_ammoAmount())
				

func arrow_attack():
	if PlayerGlobalData.arrow.has_ammo():
		var arrow_attack = PlayerGlobalData.arrow.weapon_scene.instance()
		if sign($Position2D.position.x) == 1:
			arrow_attack.set_arrow_direction(1)
		else:
			arrow_attack.set_arrow_direction(-1)
		get_parent().add_child(arrow_attack)
		arrow_attack.position = $Position2D.global_position


func fire_ball_attack():
	if PlayerGlobalData.fireBall.has_ammo():
		var fireball = PlayerGlobalData.fireBall.weapon_scene.instance()
		if sign($Position2D.position.x) == 1:
			fireball.set_fire_ball_direction(1)
		else:
			fireball.set_fire_ball_direction(-1)
		get_parent().add_child(fireball)
		fireball.position = $Position2D.global_position

func plasma_bomb_attack():
	if PlayerGlobalData.plasmaBomb.has_ammo():
		var plasma_bomb = PlayerGlobalData.plasmaBomb.weapon_scene.instance()
		if sign($Position2D.position.x) == 1:
			plasma_bomb.set_plasma_bomb_direction(1)
		else:
			plasma_bomb.set_plasma_bomb_direction(-1)
		get_parent().add_child(plasma_bomb)
		plasma_bomb.position = $Position2D.global_position
		plasma_bomb.lunch($Position2D.global_position)


#---------------------------------------------------- EVENT FUNCTION

func _on_Timer_timeout():
	timer_dash.stop()

func _on_Invulnerability_Timer_timeout():
	pass

func _on_Movement_Timer_timeout():
	can_move = true
	toggle_collided_with_enemy()

func _on_Dead_timer_timeout():
	get_tree().reload_current_scene()

func _on_Player_weapon_changed(new_weapon):
	$Fire_rate_timer.stop()
	$Fire_rate_timer.wait_time = new_weapon.get_coolDown()

func _on_Sprite_animation_finished():
	if damage_income:
		damage_income = false
	if is_attacking:
		is_attacking = false

#--------------------------------------------------------------- HEALTH
func heart_collision_check():
	if PlayerGlobalData.get_current_health() == PlayerGlobalData.get_max_health():
		set_collision_mask_bit(7,false)
	elif PlayerGlobalData.get_current_health() < PlayerGlobalData.get_max_health():
		set_collision_mask_bit(7,true)

func add_health(heal):
	$Health_up_sound.play()
	set_health(PlayerGlobalData.get_health()+heal)


func toggle_collided_with_enemy():
	if collided_with_enemy:
		collided_with_enemy = false
	else:
		collided_with_enemy = true

func get_collided_with_enemy():
	return collided_with_enemy

func enemy_detection():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider is _Enemy and !get_collided_with_enemy():
			toggle_collided_with_enemy()
			damage_taken(collision.collider.get_damage())
			if motion.x != 0:
				damage_taken_movement(sign(motion.x)*-1)
			elif motion.x == 0:
				damage_taken_movement(-1)



func damage_taken_movement(direction):
	$Movement_Timer.start()
	can_move = false
	motion.x = 0
	motion.y = 0
	motion.y += -250
	motion.x += 150*direction

func damage_taken(amount):
	if timer_invulnerability.is_stopped():
		timer_invulnerability.start()
		set_health(PlayerGlobalData.get_health() - amount)

func kill():
	set_collision_mask_bit(2,false)
	is_dead = true
	PlayerGlobalData.need_health_refill()
	$Dead_timer.start()
	

func set_health(value):
	var prev_health = PlayerGlobalData.get_health()
	PlayerGlobalData.set_health(clamp(value,0,PlayerGlobalData.get_max_health())) 
	heart_collision_check()
	if PlayerGlobalData.get_health() != prev_health:
		emit_signal("health_updated",PlayerGlobalData.get_health())
		if PlayerGlobalData.get_health() == 0:
			kill()
			emit_signal("killed")
		elif PlayerGlobalData.get_health() < prev_health :
			damage_income = true



