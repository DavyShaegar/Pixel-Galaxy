extends Node
@onready var score : int = 0
@onready var score_multiplier : float = 1.0

# Use this to make stats for the game over screen
@onready var killcount : int = 0
@onready var enemy_count: int = 0
@onready var hits_count: int = 0
@onready var powerup_count: int = 0

# Current stats of selected profile
@onready var selected_profile : String
@onready var selected_score : int
@onready var selected_kills : int

var profile_archive : ConfigFile = ConfigFile.new()
const CONFIG_PATH : String = "user://Profiles.ini"
func _ready():
		# Creates the profile file if not existent
	if !FileAccess.file_exists(CONFIG_PATH):
		profile_archive.set_value("Guest", "Score", 0)
		profile_archive.set_value("Guest", "Kills", 0)
		profile_archive.save(CONFIG_PATH)
	else:
		profile_archive.load(CONFIG_PATH)

func save_profile(profile : String, score_value : int, kills_value : int) -> void:
	profile_archive.set_value(profile, "Score", score_value)
	profile_archive.set_value(profile, "Kills", kills_value)
	profile_archive.save(CONFIG_PATH)
	
func load_profile(profile : String) -> Dictionary:
	var settings : Dictionary = {}
	for key in profile_archive.get_section_keys(profile):
		settings[key] = profile_archive.get_value(profile, key)
	return settings
	
func get_profiles() -> Dictionary:
	var profiles : Dictionary = {}
	for names in profile_archive.get_sections():
		profiles[names] = load_profile(names)
	return profiles
# In Endless mode, add time survived / 10 to score count

func delete_profile(profile : String) -> void:
	profile_archive.erase_section(profile)
	profile_archive.save(CONFIG_PATH)
	
func score_reset() -> void:
	score = 0
	score_multiplier = 1.0
	killcount = 0
