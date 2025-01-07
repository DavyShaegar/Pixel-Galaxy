extends Control

@onready var music = $PanelContainer/VBoxContainer/Music_container/Music
@onready var effects_slider = $PanelContainer/VBoxContainer/Effects_Container/Effects
@onready var music_slider = $PanelContainer/VBoxContainer/Music_Container_Slider/Music_slider
@onready var _mainmenu : Node = get_node("/root/MainMenu")

# Adjusts the option based on the settings
func _ready():
	if GameSounds.music == false:
		music.button_pressed = false
	effects_slider.value = GameSounds.effects_volume
	music_slider.value = GameSounds.music_volume

# Music on/off
func _on_music_toggled(toggled_on):
	if toggled_on == true: GameSounds.music = true
	else: GameSounds.music = false
	GameSounds.change_music(_mainmenu)
	GameSounds.menu_select.play()


# Music volume slider
func _on_music_slider_drag_ended(value_changed):
	if value_changed:
		GameSounds.change_music_volume(music_slider.value)

# Effects volume slider
func _on_effects_drag_ended(value_changed):
		if value_changed:
			GameSounds.change_sound_volume(effects_slider.value)
		GameSounds.menu_select.play()

# Go back to options
func _on_back_pressed():
	#print(GameSounds.music)
	#print(GameSounds.effects_volume)
	#print(GameSounds.music_volume)
	SaveAndLoadHandler.save_setting("Audio", "Music", GameSounds.music)
	SaveAndLoadHandler.save_setting("Audio", "Effects_Volume", GameSounds.effects_volume)
	SaveAndLoadHandler.save_setting("Audio", "Music_Volume", GameSounds.music_volume)
	
	_mainmenu.current_menu = _mainmenu.menus.options
	self.visible = false
	GameSounds.menu_select.play()
