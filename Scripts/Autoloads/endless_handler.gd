extends Node

# Spawn Position
@onready var posmark : Vector2
@onready var negmark : Vector2

# Time between spawns
@onready var rando_time : float
@onready var row_time : float

# shuffle time - change of spawn / enemy 
@onready var shuffle_time : float = 5
@onready var rng : RandomNumberGenerator = RandomNumberGenerator.new()
@onready var random : float
# Checks 
@onready var boss_present : bool = false

func _ready():
	rng.randomize()
	set_random_number()

func set_random_number() -> void:
	random = rng.randf_range(0.0,100.0)
	
func set_rando_music() -> void:
	var music = GameSounds.get_music().pick_random()
	music.play()
	
# Gets the length of the song,
# and chooses another after that time has passed
func get_music_end(music) -> void:
	await get_tree().create_timer(music.get_length).timeout 
	set_rando_music()
	
func set_shuffle_time(shuffle_timer : Timer) -> void:
	shuffle_time = rng.randf_range(2.5, 8.0)
	shuffle_timer.wait_time = shuffle_time
	
func enemyChooser() -> PackedScene:
	if random > 90.0:
		#print("Healer")
		return load("res://Scenes/Instances/enemy_healer.tscn")
	elif random > 80.0:
		#print("Heavy")
		return load("res://Scenes/Instances/enemy_heavy.tscn")
	else:
		#print("Fighter")
		return load("res://Scenes/Instances/enemy_fighter.tscn")

		
func bossChooser() -> PackedScene:
	
	boss_present = true
	if random > 90.0:
		return load("res://Scenes/Instances/enemy_dreadnought.tscn")
	elif random > 80.0:
		return load("res://Scenes/Instances/enemy_torpedo.tscn")
	else:
		return load("res://Scenes/Instances/enemy_battlecruiser.tscn")
		
	
func waveChooser() -> void:
	match randi_range(1,6):
		1:
			#print("RowSpawn")
			RowSpawn(enemyChooser())
		2:
			#print("Rando")
			RandoSpawn(enemyChooser())
		3:
			#print("RowSpawn")
			RowSpawn(enemyChooser())
		4:
			#print("RowSpawn")
			RandoSpawn(enemyChooser())
		5:
			#print("RowSpawn")
			RandoSpawn(enemyChooser())
		6:
			#print("Boss")
			BossSpawn(bossChooser())
			
func RowSpawn(spawner : PackedScene) -> void:
	var position : Vector2 = Vector2(40, randf_range(negmark.y, posmark.y))
	for i in range(9):
		var enemy = spawner.instantiate()
		enemy.global_position = position
		position += Vector2(64.0, 0.0)
		add_child(enemy)
		ScoreHandler.enemy_count += 1
		
func RandoSpawn(spawner : PackedScene) -> void:
	for iteration in randi_range(5,10):
		#print("spawn!")
		await get_tree().create_timer(1.0).timeout
		var enemy = spawner.instantiate()
		enemy.global_position = Vector2(randf_range(negmark.x, posmark.x), randf_range(negmark.y, posmark.y))
		add_child(enemy)
		ScoreHandler.enemy_count += 1
		
# Middle top of the screen
# only one boss at a time to avoid conflicts
func BossSpawn(spawner : PackedScene) -> void:
	var enemy = spawner.instantiate()
	enemy.global_position = Vector2(posmark.x /2, negmark.y /2)
	add_child(enemy)
	
	boss_present = true
	ScoreHandler.enemy_count += 1
	
# Gets the position nodes
func set_spawn_points(vector_1 : Node, vector_2 : Node) -> void:
	# Spawn Positions
	posmark = vector_1.global_position
	negmark = vector_2.global_position
