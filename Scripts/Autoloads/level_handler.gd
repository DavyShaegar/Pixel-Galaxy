class_name  level_handler
extends Node

# returns the current level running
func get_current_level() -> Node:
	if current_level == "Level_01":
		return Level1
	elif current_level == "Level_02":
		return Level2
	elif current_level == "Level_03":
		return Level3
	else: 
		return null
	
# Nodes for position and wave counter
@onready var posmark : Vector2
@onready var negmark : Vector2
@onready var wave_label : Node

# Enemies
@export_category("Enemies")
@export var base_enemy : PackedScene
@export var heavy_enemy : PackedScene
@export var boss : PackedScene
@export var Healer : PackedScene
@export var Enemy_Rocket : PackedScene

# Keeps track of the current level the player's in
@onready var current_level : String
# Wave indicator
@onready var Current_Wave : int = 0

#region Spawn Settings
# Different spawns layouts
func RowSpawn(spawner):
	var position : Vector2 = Vector2(40, randf_range(negmark.y, posmark.y))
	for i in range(9):
		var enemy = spawner.instantiate()
		enemy.global_position = position
		position += Vector2(64.0, 0.0)
		add_child(enemy)
		ScoreHandler.enemy_count += 1
		
func RandoSpawn(spawner):
	var enemy = spawner.instantiate()
	enemy.global_position = Vector2(randf_range(negmark.x, posmark.x), randf_range(negmark.y, posmark.y))
	add_child(enemy)
	ScoreHandler.enemy_count += 1

# Middle of the screen
func BossSpawn(spawner):
	var enemy = spawner.instantiate()
	enemy.global_position = Vector2(posmark.x /2, negmark.y /2)
	add_child(enemy)
	ScoreHandler.enemy_count += 1
#endregion
