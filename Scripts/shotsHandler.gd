extends Node

@export var projectile_player_base: PackedScene
@export var projectile_player_zap: PackedScene
@export var projectile_player_rock: PackedScene

@export var projectile_enemy_base: PackedScene
@export var projectile_enemy_heavy: PackedScene
@export var projectile_boss_battlecruiser: PackedScene
@export var projectile_enemy_rock: PackedScene
@export var projectile_boss_dreadnought: PackedScene

@export var boom_simple : PackedScene
@onready var alternate_shot_pos : bool

@onready var rocket_delay : Node = $RocketDelay
@onready var zapper_delay = $ZapperDelay

func _ready():
	randomize()

func on_player_shoot(player) -> void:
	var player_weapon : int = player.current_weapon_state
	var projectile_instance
	# Base single shot weapon
	if player_weapon == 0:
		projectile_instance = projectile_player_base.instantiate()
		projectile_instance.position = player.position + Vector2(0, -50)
		get_node("player_base").play()
		
	# Machine gun / Alternates left-right cannons
	elif player_weapon == 1:
		projectile_instance = projectile_player_base.instantiate()

		if alternate_shot_pos == true:
			projectile_instance.position = player.position + Vector2(15, -50)
			alternate_shot_pos = false
		else:
			projectile_instance.position = player.position + Vector2(-15, -50)
			alternate_shot_pos = true
			
		get_node("player_base").play()
		
	# Zapper
	elif player_weapon == 2:
		get_node("player_zapper").play()
		zapper_delay.start()
		await zapper_delay.timeout
		projectile_instance = projectile_player_zap.instantiate()
		projectile_instance.global_position = projectile_instance.position + Vector2(0, -40)
		player.add_child(projectile_instance)
		return
		
	# Rockets
	elif player_weapon == 3:
		# First rocket
		projectile_instance = projectile_player_rock.instantiate()
		projectile_instance.position = player.position + Vector2(0, -50)
		add_child(projectile_instance)
		get_node("player_rocket").play()
		
		# Volley separated by 0.25 seconds delay
		rocket_delay.start()
		for rockets in range(6):
			await rocket_delay.timeout
			projectile_instance = projectile_player_rock.instantiate()
			projectile_instance.position = player.position + Vector2(0, -50)
			add_child(projectile_instance)
			get_node("player_rocket").play()
		
		# Player can attack again
		await  rocket_delay.timeout
		rocket_delay.stop()
		player.canShot = true
		return

	add_child(projectile_instance)
	
func enemybase_shoot(enemy) -> void:
	if enemy.current_base_state == enemy.base_states.death: return
	var enemy_class = BehaviourFuncs.get_custom_enemy_class(enemy)
	var projectile_instance
	match enemy_class:
		0:
			projectile_instance = projectile_enemy_base.instantiate()
			projectile_instance.position = enemy.position + Vector2(0, +50)
			var random = randf()
			if random < 0.33:
				GameSounds.enemy_base_shoot_01.play()
			elif random < 0.66:
				GameSounds.enemy_base_shoot_02.play()
			else:
				GameSounds.enemy_base_shoot_03.play()
			
		1:
			projectile_instance = projectile_enemy_heavy.instantiate()
			projectile_instance.position = enemy.position + Vector2(0, +50)
		3:
			projectile_instance = projectile_boss_battlecruiser.instantiate()
			projectile_instance.position = enemy.position + Vector2(0, +20)
		5:
			projectile_instance = projectile_boss_dreadnought.instantiate()
			projectile_instance.position = enemy.position + Vector2(0, +80)
			GameSounds.dreadnought_shoot.play()
			
	add_child(projectile_instance)

func enemyrocket_shoot(enemy) -> void:
	enemy._animation.play("firing")

	# Volley separated by 0.375 seconds delay
	var rocket_count : int = 0
	for rockets in range(6):
		await get_tree().create_timer(0.375).timeout
		
		var projectile_instance = projectile_enemy_rock.instantiate()
		rocket_count += 1
		
		match rocket_count:
			1:
				projectile_instance.position = enemy.position + Vector2(-27, -50)
			2:
				projectile_instance.position = enemy.position + Vector2(27, -50)
			3:
				projectile_instance.position = enemy.position + Vector2(42, -50)
			4:
				projectile_instance.position = enemy.position + Vector2(-42, -50)
			5:
				projectile_instance.position = enemy.position + Vector2(62, -50)
			6:
				projectile_instance.position = enemy.position + Vector2(-62, -50)
				
		add_child(projectile_instance)
		get_node("player_rocket").play()
		
	rocket_count = 0
	
func bomb_killAll(scene):
	var allNodes : Array = scene.get_children()
	for node in allNodes:
		if node is Enemy:
			# Applies 999 of damage to the enemy
			BehaviourFuncs.take_damage(999, node.health, node, true)
