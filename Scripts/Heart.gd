extends Sprite


func _on_Area2D_body_entered(body):
	if body.name == "Player" and body.can_heal():
		body.heal(1)
		queue_free()
