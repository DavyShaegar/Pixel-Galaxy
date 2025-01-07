extends Control
# Resumes the game
func _on_resume_pressed():
	get_tree().paused = false
	queue_free()

# Quits to main menu
func _on_quit_pressed():
	get_tree().paused = false
	QuitResetFuncs.reset_scene()
	GameSounds.silence_music()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
