extends Area2D
			
func _on_Key_body_entered(body):
	if(body.name == "Player"):
		self.queue_free()
		body.global_player.num_keys += 1
		body.get_node("KeyHud").play("Activated")
		body.get_node("NumHud").play("%s" % body.global_player.num_keys)
		print(body.global_player.num_keys)
		
