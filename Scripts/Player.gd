extends KinematicBody2D

var has_key = false
var friction = true
var motion = Vector2()
var accelaration = 50
var gravity = 20
var up = Vector2(0, -1)
var max_speed = 300

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
