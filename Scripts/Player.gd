extends KinematicBody2D

var friction = true
var motion = Vector2()
var accelaration = 50
var gravity = 20
var up = Vector2(0, -1)
var max_speed = 300
onready var global_player = get_node("/root/GlobalPlayer")
var heart_tex = preload("res://Assets/Textures/Platformer Graphics Deluxe/HUD/hud_heartFull.png")
var half_heart_tex = preload("res://Assets/Textures/Platformer Graphics Deluxe/HUD/hud_heartHalf.png")
var empty_heart_tex = preload("res://Assets/Textures/Platformer Graphics Deluxe/HUD/hud_heartEmpty.png")
var HEART_SPACE_SIZE = 70

func _ready():
	update_health()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	motion.y += gravity

	if Input.is_action_pressed("ui_right"):
		if motion.x < max_speed:
			motion.x = motion.x + accelaration
		
		$Sprite.flip_h = false
		$Sprite.play("Walk")
		
	elif Input.is_action_pressed("ui_left"):
		if motion.x > -max_speed:
			motion.x = motion.x - accelaration
			
		$Sprite.flip_h = true
		$Sprite.play("Walk")
	else:
		motion.x = 0
		friction = true
		$Sprite.play("Idle")
	
	if is_on_floor():
		if friction:
			motion.x = lerp(motion.x, 0, 0.1)
	else:
		if(motion.y < 0):
			$Sprite.play("Jump")
		else:
			$Sprite.play("Hurt")
		
		if friction:
			motion.x = lerp(motion.x, 0, 0.05)
	
	if Input.is_action_just_pressed("ui_accept"):
		gravity = -gravity
		up[1] = -up[1]
		$Sprite.flip_v = !$Sprite.flip_v
	
	motion = move_and_slide(motion, up)

   
func round_half_down(n, decimal=0):
	var multiplier = pow(10, decimal)
	return ceil(n * multiplier - 0.5) / multiplier

func update_health():
	var integer_health = int(global_player.health) 
	var round_health = round_half_down(global_player.health)

	for i in range(round_health):
		var heart = Sprite.new()
		heart.position.x = HEART_SPACE_SIZE * i
		heart.set_texture(heart_tex)
		$HealthBar.add_child(heart)
	# Is not integer and its between .0 to .5
	if global_player.health != integer_health and integer_health == round_health:
		var half_heart = Sprite.new()
		half_heart.position.x = HEART_SPACE_SIZE * integer_health
		half_heart.set_texture(half_heart_tex)
		$HealthBar.add_child(half_heart)
	
	var ceil_health = ceil(global_player.health)
	for i in range(global_player.max_health - ceil_health):
		var empty_heart = Sprite.new()
		empty_heart.position.x = HEART_SPACE_SIZE * (ceil_health + i)
		empty_heart.set_texture(empty_heart_tex)
		$HealthBar.add_child(empty_heart)
	$HealthBar.position.x -= HEART_SPACE_SIZE * (global_player.max_health / 2.0 - 0.5)
	
	
func add_max_health(health: int):
	for i in range(health):
		var empty_heart = Sprite.new()
		empty_heart.position.x = HEART_SPACE_SIZE * (global_player.max_health + i)
		empty_heart.set_texture(empty_heart_tex)
		$HealthBar.add_child(empty_heart)
	$HealthBar.position.x -= HEART_SPACE_SIZE * health / 2.0
	global_player.max_health += health
	heal(health)
	
func can_heal():
	return round_half_down(global_player.health) != global_player.max_health
	
func heal(health):
	# If the health is overflowing the max health, heal only the needed to the max 
	if global_player.health + health > global_player.max_health:
		health = global_player.max_health - global_player.health
	
	var hearts = $HealthBar.get_children()
	var round_health = round_half_down(global_player.health)
	var final_health = global_player.health + health
	var integer_final_health = int(final_health) 
	var round_final_health = round_half_down(final_health)
	for i in range(round_health, round_final_health):
		hearts[i].set_texture(heart_tex)
	# Is not integer and its between .0 to .5
	if final_health != integer_final_health and integer_final_health == round_final_health:
		hearts[integer_final_health].set_texture(half_heart_tex)	
	
	global_player.health = final_health

	
	$Sprite.set_modulate(Color(0.607843, 1, 0.607843))
	var t = Timer.new()
	t.set_wait_time(1)
	t.set_one_shot(true)
	add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	
	$Sprite.set_modulate(Color(1, 1, 1))


func damage(health):
	var hearts = $HealthBar.get_children()
	var round_health = round_half_down(global_player.health)
	var final_health = global_player.health - health
	
	var is_dead = final_health <= 0
	if is_dead:
		final_health = 0
		death()
			
	var integer_final_health = int(final_health) 
	var round_final_health = round_half_down(final_health)
	
	for i in range(round_health, round_final_health, -1):
		hearts[i].set_texture(empty_heart_tex)
	
	# Is not integer and its between .0 to .5
	if final_health != integer_final_health and integer_final_health == round_final_health:
		hearts[integer_final_health].set_texture(half_heart_tex)
	
	global_player.health -= health

	$Sprite.modulate = Color(255, 0, 0)
	var t = Timer.new()
	t.set_wait_time(3)
	t.set_one_shot(true)
	add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	$Sprite.self_modulate = Color(255, 255, 255, 255)	

func death():
	print("You are dead")
