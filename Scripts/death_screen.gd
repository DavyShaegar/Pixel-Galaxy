extends Control


func _on_quit_desktop_pressed():
	#SaveAndLoadHandler.save_score()
	get_tree().quit()


func _on_quit_menu_pressed():
	#SaveAndLoadHandler.save_score()
	QuitResetFuncs.reset_scene()
	GameSounds.silence_music()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_resume_pressed():
	#SaveAndLoadHandler.save_score()
	QuitResetFuncs.reset_scene()
	get_tree().reload_current_scene()
