extends Node2D

# Parallax
@onready var planet_ring = $ParallaxBackground/ParallaxLayer_1
@onready var planets_far = $ParallaxBackground/ParallaxLayer_3
@onready var planet_big = $ParallaxBackground/ParallaxLayer_2
@onready var stars = $ParallaxBackground/ParallaxLayer_4
@onready var stars_2= $ParallaxBackground/ParallaxLayer_6
@onready var planet_big_2 = $ParallaxBackground/ParallaxLayer_5

@onready var background = $CanvasLayer/Background
@onready var transition_black = $CanvasLayer2/Transition_Black

@onready var score_label = $CanvasLayer2/score

@onready var despawn_area = $DespawnArea
@onready var despawnAll : Array

func changeLevelLable(level: String, timetoshow : float) -> void:
	var change_level_layer = $ChangeLevelLayer
	var level_label = $ChangeLevelLayer/Level
	change_level_layer.visible = true
	level_label.text = level
	await get_tree().create_timer(timetoshow).timeout
	change_level_layer.visible = false

func _process(_delta):
	# Parallax movement
	planet_ring.motion_offset += Vector2(0.0, 0.05)
	planets_far.motion_offset += Vector2(0.0, 0.025)
	planet_big.motion_offset += Vector2(0.0, 0.125)
	stars.motion_offset += Vector2(0.0, 0.0125)
	stars_2.motion_offset += Vector2(0.0, 0.0125)
	planet_big_2.motion_offset += Vector2(0.0, 0.2)
	
	# Removes all stuff that exits the screen i.e: Projectiles and Pickups 
	# ( Area2D don't count as body entered )
	despawnAll = despawn_area.get_overlapping_areas()
	if despawnAll != null:
		for all in despawnAll:
			all.queue_free()


func _on_despawn_area_body_entered(body):
	if body is Enemy and body.despawning == true:
		body.queue_free()


func _on_player_tree_entered():
	GameSounds.change_music(get_node("."))
	ScoreHandler.score_reset()
	LevelHandler.current_level = "Level_01"
	changeLevelLable("Level 01\n Start!", 3.0)
	Level1.first_wave.start()
	Level1.Current_Wave = 1


func _on_boss_area_body_entered(body):
	if body is Enemy_Dreadnought:
		body.healerSpawning = true
	if body is Enemy_Boss_1 or body is Enemy_Torpedo:
		body.stop = true
