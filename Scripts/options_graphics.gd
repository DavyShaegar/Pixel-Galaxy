extends Control

@onready var _mainmenu : Node = get_node("/root/MainMenu")
@onready var resolution_button = $PanelContainer/VBoxContainer/HBoxContainer2/OptionButton
@onready var fullscreen_button = $PanelContainer/VBoxContainer/HBoxContainer/CheckButton

func _ready():
	# Sets the option buttons to the correct values
	var settings = SaveAndLoadHandler.load_settings("Video")
	fullscreen_button.button_pressed = settings.Fullscreen
	match settings["Resolution"]:
		"2048x1536":
			resolution_button.selected = 1
		"1024x768":
			resolution_button.selected = 2
		"800x600":
			resolution_button.selected = 3
			
		"1536x2048":
			resolution_button.selected = 5
		"768x1024":
			resolution_button.selected = 6
		"600x800":
			resolution_button.selected = 7
			
		"1920x1080":
			resolution_button.selected = 9
		"1280x720":
			resolution_button.selected = 10
		"640x360":
			resolution_button.selected = 11
			
		_: # You can set any resolution if .ini is edited, but will show default value
			resolution_button.selected = 7
			
# Changes the resolutions between these presets
func _on_option_button_item_selected(index):
	var resolution_selected : String
	GameSounds.menu_select.play()
	match index:
		# 4:3
		1:
			DisplayServer.window_set_size(Vector2i(2048, 1536))
			resolution_selected = "2048x1536"
		2:
			DisplayServer.window_set_size(Vector2i(1024, 768))
			resolution_selected = "1024x768"
		3:
			DisplayServer.window_set_size(Vector2i(800, 600))
			resolution_selected = "800x600"
			
		# 3:4
		5:
			DisplayServer.window_set_size(Vector2i(1536, 2048))
			resolution_selected = "1536x2048"
		6:
			DisplayServer.window_set_size(Vector2i(768, 1024))
			resolution_selected = "768x1024"
		7:
			DisplayServer.window_set_size(Vector2i(600, 800))
			resolution_selected = "600x800"
			
		# 16:9
		9:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
			resolution_selected = "1920x1080"
		10:
			DisplayServer.window_set_size(Vector2i(1280, 720))
			resolution_selected = "1280x720"
		11:
			DisplayServer.window_set_size(Vector2i(640, 360))
			resolution_selected = "640x360"
			
	SaveAndLoadHandler.save_setting("Video", "Resolution", resolution_selected)
	SaveAndLoadHandler.center_window()

# Fullscreen or windowed
func _on_check_button_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		SaveAndLoadHandler.save_setting("Video", "Fullscreen", true)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		SaveAndLoadHandler.save_setting("Video", "Fullscreen", false)
	GameSounds.menu_select.play()

# Go back to options
func _on_back_pressed():
	_mainmenu.current_menu = _mainmenu.menus.options
	self.visible = false
	GameSounds.menu_select.play()
