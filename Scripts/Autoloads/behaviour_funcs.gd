extends Node
func get_player() -> Node:
	if LevelHandler.current_level != "":
		return get_node("/root/MainGame/Player")
	else:
		return get_node("/root/Endless/Player")

func get_custom_enemy_class(object) -> int:
	if object is Enemy_Heavy:
		return 1
	elif object is Enemy_Healer:
		return 2
	elif  object is Enemy_Dreadnought:
		return 5
	elif object is Enemy_Torpedo:
		return 4
	elif object is Enemy_Boss_1:
		return 3
	else: # Enemy base or player
		return 0
	
func _ready():
	randomize()
	
# Changes weapon when picks up... pickups :)
# First child is for identifying the type of pickup 
# (they all share the same script)
func ChangeWeapon(weapon, player) -> void:
	
	if weapon.get_child(0).name == "MachineGun":
		player.current_weapon_state = player.weapon_type_states.mg
		player.weapons_sprite.set_animation("mg_shoot")
		player.shotdelay = 0.1
		
	elif weapon.get_child(0).name == "RocketLauncher":
		player.current_weapon_state = player.weapon_type_states.rocket
		player.weapons_sprite.set_animation("rocket_shoot")
		player.shotdelay = 1.5
		
	elif weapon.get_child(0).name == "Railgun":
		player.current_weapon_state = player.weapon_type_states.zapper
		player.weapons_sprite.set_animation("zapper_shoot")
		player.shotdelay = 4.5
	
	ScoreHandler.powerup_count += 1
	player.pickup_timer.start()
	
func powerupdrop(player) -> String:
	var rng = randf()
	print(rng)
	# EMP Bomb (Kills every enemy on the scene)
	if rng > 0.985:
		return "res://Scenes/Instances/bomb_pickup.tscn"
	# Invincibility
	elif rng > 0.975:
		return "res://Scenes/Instances/invul_pickup.tscn"
	# RepairKit - only if player damaged
	elif rng > 0.95 && player.health != 4:
		return "res://Scenes/Instances/health_pickup.tscn"
	# No drop
	else:
		return ""
		
func weapondrop() -> String:
	var rng = randf()
	# Zapper
	if rng > 0.99:
		return "res://Scenes/Instances/zap_pickup.tscn"
	# Rockets
	elif rng > 0.98:
		return "res://Scenes/Instances/rock_pickup.tscn"
	# Machine Gun
	elif rng > 0.95:
		return "res://Scenes/Instances/mg_pickup.tscn"
	# No drop
	else:
		return ""
		
func aoe_damage(objects_in_range : Array, damage: int) -> void:
	for object in objects_in_range:
		if object is Enemy:
			take_damage(int(damage/3), object.health, object, true)
		else: 
			print("Another ", object.health)
			take_damage(int(damage/4), object.health, object, false)

# Handles all damage dealt in game (except for insta-death and AOE)
func take_damage(hit: int, health: int, collider: Object, enemy : bool) -> void:
	
	if collider.invulnerable == true or collider.current_base_state == collider.base_states.death:
		return
		
	collider.current_base_state = collider.base_states.hit
	collider.health -= hit
	
	if collider.health <= 0:
		
		if enemy == true:
			# Powerup pickup
			var check_powerup_drop = powerupdrop(get_player())
			#print(check_powerup_drop)
			if check_powerup_drop != "":
				var pickup_scene = load(check_powerup_drop)
				var pickup = pickup_scene.instantiate()
				pickup.set_position(collider.global_position)
				call_deferred("add_child", pickup)
				
			# Spawns weapon pickup only if no powerup is spawned
			var check_weapon_drop = weapondrop()
			#print(check_weapon_drop)
			if check_weapon_drop != "" && check_powerup_drop == "":
				var pickup_scene = load(check_weapon_drop)
				var pickup = pickup_scene.instantiate()
				pickup.set_position(collider.global_position)
				call_deferred("add_child", pickup)
			
			# Gives score after kill
			ScoreHandler.score += collider.base_score_points
			ScoreHandler.killcount += 1
			get_node("/root/"+get_tree().current_scene.name+"/CanvasLayer2/score").text = str(ScoreHandler.score)
			#print("Current score: " + str(ScoreHandler.score))
		
		var coll_class : int = get_custom_enemy_class(collider)
		#print(coll_class)
		match coll_class:
			0:
				GameSounds.low_boom.pitch_scale = randf_range(0.5, 1.5)
				GameSounds.low_boom.play()	
			1:
				GameSounds.heavy_boom.pitch_scale = randf_range(0.5, 0.7)
				GameSounds.heavy_boom.play()
			2:
				GameSounds.heavy_boom.pitch_scale = randf_range(0.7, 0.9)
				GameSounds.heavy_boom.play()
				collider.healorb.queue_free()
			3:
				GameSounds.enemy_boss_01_explosion.play()
			4:
				GameSounds.enemy_boss_01_explosion.play()
			5: 
				GameSounds.enemy_boss_01_explosion.play()
		
		collider.collision.queue_free()
		collider.current_base_state = collider.base_states.death
		
	else:
		var boom = ShotsHandler.boom_simple.instantiate()
		boom.position = collider.position
		add_child(boom)
		GameSounds.impact.play()

func heal_object(object, healer) -> void:
	var currenthealth = object.health
	# If healing is done by a pickup
	if healer is Pickup:
		# If the object healed is the player
		# and has less than full health
		if object is Player:
			if currenthealth < 4:
				object.health += 1
				# updates the animation
				object.current_base_state = object.base_states.hit
				return
		else:
			object.health += 1
	else:
		# add 
		pass

func add_invul(object) -> void:
	if object is Player:
		object.invulnerable = true
		object.invul_sprite.visible = true
		ScoreHandler.powerup_count += 1
		object.invul_timer.start()
		
func save_score() -> void:
	# Guest and invalid profiles don't save progress
	if ScoreHandler.selected_profile == "Guest" or ScoreHandler.selected_profile not in ScoreHandler.get_profiles():
		return
	# Saves the score if higher than previous one
	if ScoreHandler.score > ScoreHandler.selected_score:
		ScoreHandler.save_profile(ScoreHandler.selected_profile, ScoreHandler.score, ScoreHandler.killcount)
	# if somehow killcount is higher but score is not...
	elif ScoreHandler.killcount > ScoreHandler.selected_kills:
		ScoreHandler.save_profile(ScoreHandler.selected_profile, ScoreHandler.selected_score, ScoreHandler.killcount)
		
		
func change_background(scene, level : int) -> void:
	"""
	@onready var planets_far = $ParallaxBackground/ParallaxLayer_3
	@onready var planet_big = $ParallaxBackground/ParallaxLayer_2
	"""
	if level == 2: # Level 2
		scene.background.texture = load("res://Graphics/Background/Level_2/Stars.png")
		scene.stars.get_child(0).texture = load("res://Graphics/Background/Level_2/Nebula.png")
		scene.stars_2.get_child(0).texture = load("res://Graphics/Background/Level_2/Nebula_2.png")
		scene.planet_ring.get_child(0).texture = load("res://Graphics/Background/Level_2/Planets.png")
		scene.planet_big_2.get_child(0).texture = load("res://Graphics/Background/Level_2/Planet.png")
		
		scene.planets_far.get_child(0).texture = null
		scene.planet_big.get_child(0).texture = null
		
	elif level == 3: # Level 3
		scene.background.texture = load("res://Graphics/Background/Level_3/Stars_3.png")
		scene.stars.get_child(0).texture = load("res://Graphics/Background/Level_3/Nebula_3.png")
		scene.stars_2.get_child(0).texture = load("res://Graphics/Background/Level_3/Dust_3.png")
		scene.planet_ring.get_child(0).texture = load("res://Graphics/Background/Level_3/Planets_3.png")
		scene.planet_big_2.get_child(0).texture = load("res://Graphics/Background/Level_3/Planets_2_3.png")
		
		scene.planets_far.get_child(0).texture = null
		scene.planet_big.get_child(0).texture = null
	
# in_out == true - Fade In; False - Fade Out
func cross_fade(scene, in_out : bool) -> void:
	if in_out == true:
		for i in range(101): # Fade in
			await get_tree().create_timer(0.01).timeout
			scene.transition_black.color += Color(0, 0, 0, 0.01)
	else:
		for i in range(101): # Fade out
			await get_tree().create_timer(0.01).timeout
			scene.transition_black.color -= Color(0, 0, 0, 0.01)
			
func end_level_01() -> void:
	save_score()
	
	# Changes the scene background to simulate a change of location
	var game_scene : Node2D = get_node("/root/MainGame")
	cross_fade(game_scene, true)

	await get_tree().create_timer(0.5).timeout
	
	game_scene.changeLevelLable("Changing\nGalaxy...", 2.8)
	
	await get_tree().create_timer(2.8).timeout
	
	change_background(game_scene, 2)
	
	# Removes all traces of the first level
	QuitResetFuncs.reset_scene()
	# Changes to music level 2
	GameSounds.change_level_music(false, 1)
	
	cross_fade(game_scene, false)
	
	game_scene.changeLevelLable("Level 02 \n Start!", 3.0)
	LevelHandler.current_level = "Level_02"
	Level2.first_wave.start()
	
func end_level_02() -> void:
	save_score()
	
	# Changes the scene background to simulate a change of location
	var game_scene : Node2D = get_node("/root/MainGame")
	# Fade to black
	cross_fade(game_scene, true)
	
	await get_tree().create_timer(0.5).timeout
	
	game_scene.changeLevelLable("Changing\nGalaxy...", 2.8)
	
	await get_tree().create_timer(2.8).timeout
	
	change_background(game_scene, 3)
	
	# Removes all traces of the first level
	QuitResetFuncs.reset_scene()
	# Changes to music level 2
	GameSounds.change_level_music(false, 2)
	
	# Fade from black
	cross_fade(game_scene, false)

	game_scene.changeLevelLable("Level 03 \n Start!", 3.0)
	LevelHandler.current_level = "Level_03"
	#Level3.first_wave.start()

func endstorymode() -> void:
	# Changes the scene background to simulate a change of location
	var game_scene : Node2D = get_node("/root/MainGame")
	# Fade to black
	cross_fade(game_scene, true)
	
	await get_tree().create_timer(2.0).timeout
	
	# Fade from black
	#cross_fade(game_scene, false)
	GameSounds.change_level_music(false)
	QuitResetFuncs.reset_scene()
	get_tree().change_scene_to_file("res://Scenes/endgamecredits.tscn")
