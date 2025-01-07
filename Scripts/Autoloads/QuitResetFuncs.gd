extends Node
# Clears all the projectiles from the scene
func removeallprojectiles(Scene : Node):
	var children = Scene.get_children()
	for child in children:
		if child is Projectile:
			child.queue_free()
# Clears all the enemies from the scene
func removeallenemies(Scene : Node):
	var children = Scene.get_children()
	for child in children:
		if child is Enemy:
			child.queue_free()
# Stops all timers for the waves
func stop_timers(timers):
	for child in timers:
		#print(child.name)
		child.stop()
		
		# Timers may have children that will need to be stopped as well
		if child.get_child_count() != 0:
			var timers_2ndGen : Array = child.get_children()
			
			for child_2ndGen in timers_2ndGen:
				#print(child_2ndGen.name)
				child_2ndGen.stop()

# All in one
func reset_scene():
	var scene : String = get_tree().current_scene.name
	var all_timers : Array
	if scene == "MainGame":
		
		match Level1.Current_Wave:
			1:
				var first_wave = Level1.first_wave
				first_wave.stop()
				all_timers = first_wave.get_children() 
			2:
				all_timers = Level1.second_wave.get_children() 
			3:
				var third_wave = Level1.third_wave
				all_timers = third_wave.get_children() 
				third_wave.stop()
				
		GameSounds.level_1_music.stop()
		
	elif scene == "Endless":
		#var all_timers : Array = get_children() 
		#_stop_timers(all_timers)
		QuitResetFuncs.removeallenemies(get_node("/root/EndlessHandler"))
		GameSounds.endless_music.stop()
		
	removeallprojectiles(get_node("/root/ShotsHandler"))
	# Add the other levels
	removeallenemies(get_node("/root/Level1"))
	stop_timers(all_timers)
