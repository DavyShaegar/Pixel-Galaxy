extends Enemy
class_name Enemy_Healer

@onready var healorb = $healorb

func _ready():

	_raycast = null # DUMMY - Not Used
	health = 3
	speed = 20
	shoot_delay = 2.0
	base_score_points = 10
	
func _heal():

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
			2: # Healers - Doesn't heal to full health (just -1)
				if object.health >= 2: continue
			3: # BattleCruiser - Boss 1
				if object.health >= 50: continue
			4: # Torpedo - Boss 2
				if object.health >= 75: continue
			5: # Dreadnought - Boss 3
				if object.health >= 100: continue
			0: # Base - Not used
				if object.health >= 1: continue
		
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
			print("heal")
			healorb.set_animation("healing")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if death() == true:
		death()
		
	if $Heal_Area.has_overlapping_bodies() and cooldown == false:
		_heal()
		
	enemy_move_collide(delta)

func _on_animated_sprite_2d_animation_finished():
	if current_base_state == base_states.death:
		queue_free()
		
func _on_shotcooldown_timeout():
	cooldown = false
	_shotcooldown.stop()


func _on_healorb_animation_finished():
	if healorb.animation == "healing":
		healorb.play("default")
