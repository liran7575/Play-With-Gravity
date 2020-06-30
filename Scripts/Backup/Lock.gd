extends StaticBody2D

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		if body.global_player.num_keys > 0:
			body.global_player.num_keys -= 1
			body.get_node("NumHud").play("%s" % body.global_player.num_keys)
			self.queue_free()
			
			if(body.global_player.num_keys) < 1:
				body.get_node("KeyHud").play("Disabled")
