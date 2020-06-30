extends Area2D

export var pressed = false;

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	
	for body in bodies:
		if body.name == "Player":
			pressed = true
	
	if pressed:
		$Sprite.play("Pressed")
		Global.is_pressed = true
		
	else:
		$Sprite.play("Idle")
