extends Enemy_Healer

func _ready():
	health = 1
	speed = 18
	shoot_delay = 3
	base_score_points = 15
	var healgfx : PackedScene = preload("res://Scenes/Instances/healGFX.tscn")
	var all_objects : Array = $Heal_Area.get_overlapping_bodies()
	var object_class : int
	var healed : bool = false
	
	if death() == true:
		return
		
	# All the objects in range
	for object in all_objects:
		# Skips itself
		if object == self:
			continue 
		# If not only itself in area, starts cooldown for next heal wave
		cooldown = true
		_shotcooldown.start()

		
		#print("Object: " + str(object))
		object_class = BehaviourFuncs.get_custom_enemy_class(object)	
		#print("Object Class Number: " + str(object_class))
		
		# Gets the max health for all enemies 
		# and skips if already at max value (prevents over-heal)
		match object_class:
			1: # Heavy
				if object.health >= 5: continue
				#print("Heavy Found")
				
			2: # Healers
				if object.health >= 3: continue
				#print("Healer Found")
				
			0: # Base - Not used
				if object.health >= 1: continue
				#print("Base Found")
		
		# Heals
		#print("Health: " + str(object.health))
		object.health += 1
		#print("Healed! Now: " + str(object.health))
		healed = true
		
		# Adds the GFX
		var healgfx_insta = healgfx.instantiate()
		object.add_child(healgfx_insta)
		
		# Plays the animation only if healed something
		if healed == true:
			healorb.set_animation("healing")

func _process(delta):
	if death() == true:
		death()
		
	if $Heal_Area.has_overlapping_bodies() and cooldown == false:
		_heal()
	
	if position.y < 125: # Stops in front of the boss
		enemy_move_collide(delta)
