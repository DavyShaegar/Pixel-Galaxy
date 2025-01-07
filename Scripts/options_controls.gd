extends Control

@onready var _mainmenu : Node = get_node("/root/MainMenu")
@onready var commands_container = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/ScrollContainer/CommandsContainer

func _load_commands()-> void:
	var commands : Dictionary = SaveAndLoadHandler.load_settings("Bindings")
	var count : int = 0
	for names in commands:
		commands_container.get_child(count).text = commands[names]
		count += 1
		
func _save_commands()-> void:
	var all_commands : Array = commands_container.get_children()
	for child in all_commands:
		SaveAndLoadHandler.save_setting("Bindings", child.name, child.text)
		
func _ready():
	_load_commands()

func _on_back_pressed():
	_save_commands()
	
	_mainmenu.current_menu = _mainmenu.menus.options
	self.visible = false
	GameSounds.menu_select.play()



