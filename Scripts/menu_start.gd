extends Control

@onready var _mainmenu : Node = get_node("/root/MainMenu")

# Starts a new game
func StartNewGame():
	GameSounds.main_menu_music.stop()
	get_tree().change_scene_to_file("res://Scenes/main_game.tscn")
	
func StartEndlessMode():
	GameSounds.main_menu_music.stop()
	get_tree().change_scene_to_file("res://Scenes/endless.tscn")

func _on_back_pressed():
	_mainmenu.current_menu = _mainmenu.menus.main
	self.visible = false
	GameSounds.menu_select.play()


func _on_story_pressed():
	StartNewGame()


func _on_endless_pressed():
	StartEndlessMode()
