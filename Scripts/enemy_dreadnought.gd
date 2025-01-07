extends Enemy_Boss_1
class_name Enemy_Dreadnought

@onready var healerSpawning : bool = false
@onready var HealerCount : int = 0
@onready var healer_spawn_timer = $healerSpawnTimer

### spawns healers behind it 
### these healers should become stationary when they're in front of the boss
func summonHealer():
	var healer : PackedScene = load("res://Scenes/Instances/enemy_healer_bossSpawn.tscn")
	var oHealer = healer.instantiate()
	oHealer.position = position - Vector2(randi_range(-150, 150), 250)
	add_sibling(oHealer)
	
	healerSpawning = true
	HealerCount += 1
	
func shoot(ShotDelay):
	cooldown = true
	_shotcooldown.start()
	await get_tree().create_timer(ShotDelay).timeout
	ShotsHandler.enemybase_shoot(self)
	
func _ready():
	speed = 50
	health = 1
	base_score_points = 1000
	randomize()

func _process(delta):
	if death() == true: 
		death()
		return
	if stop != true:
		enemy_move_collide(delta)
	else:
		if should_move == true:
			horizontal_random_movement(next_move)
		
		if movecooldown.is_stopped():
			movecooldown.start()
			
		if cooldown == false:
			shoot(0.3)
			
		if healerSpawning == true and HealerCount < 3:
			healer_spawn_timer.start()
			healerSpawning = false

func _on_animated_sprite_2d_animation_finished():
	if current_base_state == base_states.death:
		
		# Ends the game if in story mode 
		if LevelHandler.get_current_level() != null: 
			ShotsHandler.bomb_killAll(LevelHandler.get_current_level())
			QuitResetFuncs.removeallprojectiles(LevelHandler.get_current_level())
			BehaviourFuncs.endstorymode()
		else:
			EndlessHandler.boss_present = false
			
		queue_free()


func _on_healer_spawn_timer_timeout():
	summonHealer()
