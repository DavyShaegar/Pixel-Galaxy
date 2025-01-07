extends Control

@onready var _mainmenu : Node = get_node("/root/MainMenu")

@onready var players_container = $PanelContainer/Name/Players_container
@onready var scores_container = $PanelContainer/Score/Scores_container
@onready var kills_container = $PanelContainer/Kills/Kills_container

@onready var leaderboard_populated : bool = false

# Sorts the profiles from the highest score to the lowest
func sort_profiles(profiles : Dictionary) -> Array:
	var profile_list : Array = []
	var temp_profile_dict : Dictionary = {}
	
	for names in profiles:
		temp_profile_dict["Name"] = names
		temp_profile_dict.merge(profiles[names], true)
		profile_list.append(temp_profile_dict.duplicate(true))
	
	profile_list.sort_custom(func(a,b): if a["Score"] > b["Score"]: return true)
	return profile_list
	
# Creates the leaderboard
func create_leaderboard(profiles : Dictionary) -> void:
	# If the leaderboard has records already, clear everything
	if leaderboard_populated == true:
		var players : Array = players_container.get_children()
		for names in players:
			names.queue_free()
			
		var scores : Array = scores_container.get_children()
		for value in scores:
			value.queue_free()
			
		var kills : Array = kills_container.get_children()
		for value in kills:
			value.queue_free()
			
			
	var sorted_profiles : Array = sort_profiles(profiles)
	for profile in range(len(sorted_profiles)):	
		# Guest profile is not included in the leaderboard
		if sorted_profiles[profile]["Name"] == "Guest":
			continue
			
		var new_name: Node = Label.new()
		new_name.text = sorted_profiles[profile]["Name"]
		players_container.add_child(new_name)
		
		var new_score : Node = Label.new()
		new_score.text = str(sorted_profiles[profile]["Score"])
		scores_container.add_child(new_score)
		
		var new_kills : Node = Label.new()
		new_kills.text = str(sorted_profiles[profile]["Kills"])
		kills_container.add_child(new_kills)
		
		leaderboard_populated = true
		
func _ready():
	var profiles : Dictionary = ScoreHandler.get_profiles()
	create_leaderboard(profiles)
		
func _on_back_pressed():
	_mainmenu.current_menu = _mainmenu.menus.main
	self.visible = false
	GameSounds.menu_select.play()
