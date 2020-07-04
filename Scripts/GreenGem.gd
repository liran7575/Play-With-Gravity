extends Sprite

func _on_Area2D_body_entered(body):
	if body.name == 'Player':
		body.add_max_health(1)
		queue_free()
