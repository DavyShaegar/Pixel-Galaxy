extends Control
@onready var stars = $FrontLayer/Sprite2D
@onready var stars_zoom : bool = true
@onready var ui_container : Node = $UILayer/UIMenuButtons
@export var Buttons : PackedScene

@onready var new_profile_box = $UILayer/GameProfiles/NewProfileBox
@onready var error_too_long = $UILayer/GameProfiles/ErrorTooLong
@onready var error_already_exists = $UILayer/GameProfiles/ErrorAlreadyExists
@onready var profiles = $UILayer/GameProfiles/Profiles
@onready var delete = $UILayer/GameProfiles/Delete

enum menus {main, options, option_graphics, option_sounds, option_controls, stats, playmodes}
@onready var current_menu = menus.main

func load_profiles_menu():
	var all_profiles : Dictionary = ScoreHandler.get_profiles()
	for names in all_profiles.keys():
		profiles.add_item(names)
	# Selects guest profile as default
	profiles.selected = 2
	delete.visible = false
	
# Resets the profile menu
func clear_profiles_menu(menu : Node):
	menu.clear()
	menu.add_item("Add New Profile", 0)
	menu.add_separator("")

# Called when the node enters the scene tree for the first time.
func _ready():
	var main_buttons = Buttons.instantiate()
	ui_container.add_child(main_buttons)
	GameSounds.change_music(self)
	
	# add all profiles to the list when loading for the first time
	load_profiles_menu()
		
func _process(delta):
	# Background
	if stars_zoom == true:
		stars.scale += Vector2(0.005 * delta, 0.005 * delta)
		if stars.scale >= Vector2(1.25, 1.25):
			stars_zoom = false
	else:
		stars.scale -= Vector2(0.005 * delta, 0.005 * delta)
		if stars.scale <= Vector2(0.99, 0.99):
			stars_zoom = true
			
	# Menu Behaviour handler
	match current_menu:
		menus.main:
			get_node("UILayer/UIMenuButtons/Menu_Buttons").visible = true
		menus.options:
			get_node("UILayer/UIMenuButtons/Options").visible = true
		menus.option_graphics:
			get_node("UILayer/UIMenuButtons/options_graphics").visible = true
		menus.option_sounds:
			get_node("UILayer/UIMenuButtons/options_sounds").visible = true
		menus.option_controls:
			get_node("UILayer/UIMenuButtons/options_controls").visible = true
		menus.stats:
			get_node("UILayer/UIMenuButtons/Stats").visible = true
		menus.playmodes:
			get_node("UILayer/UIMenuButtons/MenuStart").visible = true


func _on_github_pressed():
	OS.shell_open("https://github.com/DavyShaegar")

func _on_github_mouse_entered():
	self.get_tooltip()


# Profile menu Handler
func _on_profiles_item_selected(index):
	# hides the "already exists" error, if active
	if error_already_exists.visible == true:
		error_already_exists.visible = false
		
	if index == 0:
		new_profile_box.visible = true
		delete.visible = false
	else: 
		new_profile_box.visible = false
		delete.visible = false
		if index != 2:
			delete.visible = true
		new_profile_box.clear()
		
		# Updates the selected profile
		ScoreHandler.selected_profile = profiles.get_item_text(index)
		
		var profile : Dictionary = ScoreHandler.load_profile(profiles.get_item_text(index))
		ScoreHandler.selected_score = profile["Score"]
		ScoreHandler.selected_kills = profile["Kills"]


# Add profile
func _on_new_profile_box_text_submitted(new_text):
	# Empty profile names are not allowed
	if new_text.lstrip(" ") == "":
		return
		
	# if new profile is not in the file already, create a new profile
	var all_profiles : Dictionary = ScoreHandler.get_profiles()

	if new_text not in all_profiles.keys():
		
		# hides the "already exists" error, if active
		if error_already_exists.visible == true:
			error_already_exists.visible = false
			
		ScoreHandler.save_profile(new_text, 0, 0)
		profiles.add_item(new_text)
		
	else:
		# Profile already exists
		error_already_exists.visible = true


# Name too long
func _on_new_profile_box_text_change_rejected(_rejected_substring):
	error_too_long.visible = true
# Remove too long warning if text no longer overflows 
func _on_new_profile_box_text_changed(new_text):
	if new_text.length() <= 8:
		error_too_long.visible = false

# Deletes selected profile
func _on_delete_pressed():
	ScoreHandler.delete_profile(profiles.get_item_text(profiles.selected))
	
	# Resets the profile menu
	clear_profiles_menu(profiles)
	load_profiles_menu()
