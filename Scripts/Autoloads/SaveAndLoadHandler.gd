extends Node
var configuration : ConfigFile = ConfigFile.new()
const CONFIG_PATH : String = "user://Settings.ini"

func save_setting(key_section : String, key : String, value) -> void:
	configuration.set_value(key_section, key, value)
	configuration.save(CONFIG_PATH)
	
func load_settings(key_section : String) -> Dictionary:
	var settings : Dictionary = {}
	for key in configuration.get_section_keys(key_section):
		settings[key] = configuration.get_value(key_section, key)
	return settings
	
# Saves the score 
func save_score(resource: Resource) -> void:
	ResourceSaver.save(resource, "./UserData/Games", 8)
	
# Saves the game (last level completed)


# Updates the graphics settings when game boots up
func updateGraphics() -> void:
	var settings : Dictionary = load_settings("Video")
	if settings["Fullscreen"] == true: # Fullscreen
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else: # Windowed and sets resolution (with window centering)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		var resolution : Array = settings["Resolution"].split("x")
		DisplayServer.window_set_size(Vector2i(int(resolution[0]), int(resolution[1])))
		center_window()
	
# Not my function
func center_window() -> void:
	# Get the current window
	var window = get_window()
	# And get the current screen the window's in
	var screen = window.current_screen
	# Get the usable rect for that screen
	var screen_rect = DisplayServer.screen_get_usable_rect(screen)
	# Get the window's size
	var window_size = window.get_size_with_decorations()
	# Set its position to the middle
	window.position = screen_rect.position + (screen_rect.size / 2 - window_size / 2)
	
func _ready():
	# Creates the config file if not existent
	if !FileAccess.file_exists(CONFIG_PATH):
		configuration.set_value("Video", "Resolution", "600x800")
		configuration.set_value("Video", "Fullscreen", false)
		
		configuration.set_value("Audio", "Effects_Volume", 0.8)
		configuration.set_value("Audio", "Music_Volume", 0.5)
		configuration.set_value("Audio", "Music", true)
		
		configuration.set_value("Bindings", "Up", "W")
		configuration.set_value("Bindings", "Down", "S")
		configuration.set_value("Bindings", "Left", "A")
		configuration.set_value("Bindings", "Right", "D")
		configuration.set_value("Bindings", "Shoot", "Space")
		configuration.set_value("Bindings", "Pause", "Escape")
	
		configuration.save(CONFIG_PATH)
		
	# Loads the config file
	else:
		configuration.load(CONFIG_PATH)
		
	# Sets Fullscreen / screen resolution
	updateGraphics()
