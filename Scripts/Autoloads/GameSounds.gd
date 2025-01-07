extends Node
## Handles sounds settings

# Default values
@onready var music : bool = true
@onready var music_volume : float = 1.0
@onready var effects_volume : float = 1.0
enum scenes {menu, level_1, level_2}
@onready var current_scene : int

# All game sounds
@onready var sfx_group = $SFX

@onready var low_boom = $SFX/Low_Boom
@onready var heavy_boom = $SFX/Heavy_Boom
@onready var heavy_charge = $SFX/Heavy_Charge
@onready var pickup_weapon = $SFX/Pickup_Weapon
@onready var menu_select = $SFX/menu_select
@onready var impact = $SFX/Impact

@onready var enemy_base_shoot_01 = $SFX/EnemyBase_Shoot_01
@onready var enemy_base_shoot_02 = $SFX/EnemyBase_Shoot_02
@onready var enemy_base_shoot_03 = $SFX/EnemyBase_Shoot_03
@onready var enemy_boss_01_shoot = $SFX/EnemyBoss01_shoot
@onready var enemy_boss_01_explosion = $SFX/EnemyBoss01_explosion
@onready var dreadnought_shoot = $SFX/DreadnoughtShoot

@onready var heal_player = $SFX/Heal_Player
@onready var pickup_nuclear = $SFX/pickup_nuclear
@onready var invul_up = $SFX/Invul_up
@onready var invul_down = $SFX/Invul_down


# All game music
@onready var music_group = $Music
@onready var level_1_music = $Music/Level1Music
@onready var endless_music = $Music/EndlessMusic
@onready var level_2_music = $Music/Level2Music
@onready var level_3_music = $Music/Level3Music
@onready var thanks_music = $Music/ThanksMusic

@onready var main_menu_music = $Music/MainMenuMusic

# Loads the sounds settings from the config file and applies them
func _ready():
	var settings = SaveAndLoadHandler.load_settings("Audio")
	music = settings.Music
	change_music_volume(settings.Music_Volume)
	change_sound_volume(settings.Effects_Volume)


# Applies music volume change
func change_music_volume(volume) -> void:
	music_volume = volume
	var music_children : Array = music_group.get_children() 
	for child in music_children: 
		child.volume_db = volume
		
		
# Applies sound volume change
func change_sound_volume(volume) -> void:
	effects_volume = volume
	var sound_children : Array = sfx_group.get_children() 
	for child in sound_children: 
		child.volume_db = volume
		
# Changes the game music based on the scene 
# Handles muting option as well
func change_music(scene : Node) -> void: # OBSOLETE AND I'M LAZY
	if music == true:
		match scene.name:
			"MainMenu":
				main_menu_music.play()
			"MainGame":
				level_1_music.play()
				
	else:
		main_menu_music.stop()
		
		
func change_level_music(endless : bool, current_level : int = 0) -> void:
	if endless == true:
		pass # random for endless mode - change music file, not node
	else:
		if current_level == 1:
			level_1_music.stop()
			level_2_music.play()
		elif current_level == 2:
			level_2_music.stop()
			level_3_music.play()
		else:
			level_1_music.stop()
			level_2_music.stop()
			level_3_music.stop()
			
func invul_down_playLoop():
	await get_tree().create_timer(15.0).timeout
	invul_down.play()

func get_music() -> Array:
	return music_group.get_children() 

func silence_music() -> void:
	for i in get_music():
		i.stop()
	
