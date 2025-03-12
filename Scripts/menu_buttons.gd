extends Control

# Other menus
@export var mainOptions : PackedScene 
@export var Stats : PackedScene
@export var playMenu : PackedScene 
@onready var _mainmenu : Node = get_node("/root/MainMenu")
@onready var menus_opened: Array = []
@onready var Stats_insta: Node


#(add later load game and, endless mode)
func _on_start_pressed():
	_mainmenu.current_menu = _mainmenu.menus.playmodes
	self.visible = false
	
	GameSounds.menu_select.play()
	
	if "play_menu" in menus_opened: return
	
	menus_opened.append("play_menu")
	var playMenu_insta = playMenu.instantiate()
	add_sibling(playMenu_insta)
	
# Quits the game
func _on_exit_pressed():
	get_tree().quit()
# Opens the options menu
func _on_options_pressed():
	_mainmenu.current_menu = _mainmenu.menus.options
	self.visible = false
	
	GameSounds.menu_select.play()
	
	if "options" in menus_opened: return
	
	menus_opened.append("options")
	var mainOptions_insta = mainOptions.instantiate()
	add_sibling(mainOptions_insta)
	
# Opens the stats menu
func _on_stats_pressed():
	_mainmenu.current_menu = _mainmenu.menus.stats
	self.visible = false
	
	GameSounds.menu_select.play()
	
	if "stats" in menus_opened:
		var profiles : Dictionary = ScoreHandler.get_profiles()
		Stats_insta.create_leaderboard(profiles)
		return
		
	menus_opened.append("stats")
	Stats_insta = Stats.instantiate()
	Stats_insta.position = Stats_insta.position + Vector2(-150, -100)
	add_sibling(Stats_insta)
