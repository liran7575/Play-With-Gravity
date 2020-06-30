# WorldComplete.gd
extends Area2D

export(String, FILE, "*.tscn") var next_level

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	var t = Timer.new()
	
	for body in bodies:
		if body.name == "Player":
			$Sprite.play("Wave")
			
			get_tree().change_scene(next_level)
			
		else:
			$Sprite.play("Idle")
