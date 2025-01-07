extends Control
@export var graphics : PackedScene
@export var sounds : PackedScene
@export var controls : PackedScene
@onready var _mainmenu : Node = get_node("/root/MainMenu")

func _on_back_pressed():
	_mainmenu.current_menu = _mainmenu.menus.main
	self.visible = false
	GameSounds.menu_select.play()

func _on_graphics_pressed():
	_mainmenu.current_menu = _mainmenu.menus.option_graphics
	self.visible = false
	
	GameSounds.menu_select.play()
	
	if get_node("/root/MainMenu/UILayer/UIMenuButtons/options_graphics") != null: return
	var graphics_insta = graphics.instantiate()
	graphics_insta.global_position -= Vector2(50,0)
	add_sibling(graphics_insta)


func _on_sounds_pressed():
	_mainmenu.current_menu = _mainmenu.menus.option_sounds
	self.visible = false
	
	GameSounds.menu_select.play()
	
	if get_node("/root/MainMenu/UILayer/UIMenuButtons/options_sounds") != null: return
	var sounds_insta = sounds.instantiate()
	sounds_insta.global_position -= Vector2(50,0)
	add_sibling(sounds_insta)


func _on_controls_pressed():
	_mainmenu.current_menu = _mainmenu.menus.option_controls
	self.visible = false
	
	GameSounds.menu_select.play()
	
	if get_node("/root/MainMenu/UILayer/UIMenuButtons/options_controls") != null: return
	var controls_insta = controls.instantiate()
	controls_insta.global_position -= Vector2(50,0)
	add_sibling(controls_insta)
