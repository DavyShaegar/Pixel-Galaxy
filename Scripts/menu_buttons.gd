extends Control

# Other menus
@export var mainOptions : PackedScene 
@export var Stats : PackedScene
@export var playMenu : PackedScene 
@onready var _mainmenu : Node = get_node("/root/MainMenu")


#(add later load game and, endless mode)
func _on_start_pressed():
	_mainmenu.current_menu = _mainmenu.menus.playmodes
	self.visible = false
	
	GameSounds.menu_select.play()
	
	if get_node("/root/MainMenu/UILayer/UIMenuButtons/MenuStart") != null: return
	
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
	
	if get_node("/root/MainMenu/UILayer/UIMenuButtons/Options") != null: return
	
	var mainOptions_insta = mainOptions.instantiate()
	add_sibling(mainOptions_insta)
	
# Opens the stats menu
func _on_stats_pressed():
	_mainmenu.current_menu = _mainmenu.menus.stats
	self.visible = false
	
	GameSounds.menu_select.play()
	
	if get_node("/root/MainMenu/UILayer/UIMenuButtons/Stats") != null: 
		var profiles : Dictionary = ScoreHandler.get_profiles()
		get_node("/root/MainMenu/UILayer/UIMenuButtons/Stats").create_leaderboard(profiles)
		return
	var Stats_insta = Stats.instantiate()
	Stats_insta.position = Stats_insta.position + Vector2(-150, -100)
	add_sibling(Stats_insta)
