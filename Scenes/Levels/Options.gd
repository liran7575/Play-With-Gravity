extends VBoxContainer

signal button_fade_in_finished;
signal button_fade_out_finished;

func button_fade_in():
	$".".visible = true
	$AnimationPlayer.play("button_fade_in")
	
func button_fade_out():
	$".".visible = true
	$AnimationPlayer.play("button_fade_out")

func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == "button_fade_in"):
		emit_signal("button_fade_in_finished")
		
	elif(anim_name == "button_fade_out"):
		emit_signal("button_fade_out_finished")
		$".".visible = false
