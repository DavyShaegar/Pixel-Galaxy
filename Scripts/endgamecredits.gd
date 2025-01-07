extends Control

func _on_tree_entered():
	
	BehaviourFuncs.save_score() # Saves IMMEDIATELY
	GameSounds.thanks_music.play()
	
	var enemy_count = $PanelContainer/HBoxContainer/VBoxContainer/EnemyCount
	var hits_taken = $PanelContainer/HBoxContainer/VBoxContainer/HitsTaken
	var powerup_picked_up = $PanelContainer/HBoxContainer/VBoxContainer/PowerupPickedUp
	
	enemy_count.text = str(ScoreHandler.killcount)+ "/" +str(ScoreHandler.enemy_count)
	hits_taken.text = str(ScoreHandler.hits_count)
	powerup_picked_up.text = str(ScoreHandler.powerup_count)

# This saves your progress as well.
# click it or you'll lose your pro... you know what? ^ Look up ^
func _on_button_2_pressed():
	#BehaviourFuncs.save_score() # It's better this way
	GameSounds.thanks_music.stop()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
