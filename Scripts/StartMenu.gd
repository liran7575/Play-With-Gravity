extends Control

func _ready():
	
	$CenterContainer.visible = false;
	$Fade.show()
	$Fade.fade_in()

func _on_Start_pressed():
	$CenterContainer/Options/Click.play()
	$CenterContainer/Options.button_fade_out()

func _on_Quit_pressed():
	$CenterContainer/Options/Click.play()
	$Fade.fade_out()

func _on_Fade_fade_in_finished():
	$CenterContainer/Options.show()
	$CenterContainer/Options.button_fade_in()
	$CenterContainer.visible = true;

func _on_Fade_fade_out_finished():
	get_tree().quit()

func _on_Start_mouse_entered():
	$CenterContainer/Options/Hover.play()

func _on_Quit_mouse_entered():
	$CenterContainer/Options/Hover.play()

func _on_Options_button_fade_out_finished():
	get_tree().change_scene("res://Scenes/Levels/Level0.tscn")
