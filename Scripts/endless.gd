extends Node2D


@onready var time = $CanvasLayer2/Time
@onready var seconds = $TimerNode/Seconds
@onready var minutes : int = 0
# Really?
@onready var hours : int = 0

@onready var marker_positive = $SpawnArea/Marker_positive
@onready var marker_negative = $SpawnArea/Marker_negative

@onready var shuffle = $TimerNode/Shuffle

func _changeLevelLable(level: String) -> void:
	var change_level_layer = $ChangeLevelLayer
	var level_label = $ChangeLevelLayer/Level
	level_label.text = level
	await get_tree().create_timer(3.0).timeout
	change_level_layer.visible = false

func _ready():
		# Resets the score if there is any
	ScoreHandler.score_reset()
	# No level is playing
	LevelHandler.current_level = ""
	# Starts the music
	EndlessHandler.set_rando_music()

	# Starts the endless mode
	EndlessHandler.set_spawn_points(marker_positive, marker_negative)
	EndlessHandler.waveChooser()

func _process(_delta):
	
	if hours != 0:
		time.text = "Time: " + str(hours)+ " : " +str(minutes) + " : " + str(floor(seconds.wait_time) - floor(seconds.time_left))
	elif minutes != 0:
		time.text = "Time: " + str(minutes) + " : " + str(floor(seconds.wait_time) - floor(seconds.time_left))
	else:
		time.text = "Time: " + str(floor(seconds.wait_time) - floor(seconds.time_left))


func _on_seconds_timeout():
	
	if minutes >= 59:
		minutes = 0
		hours += 1
		return
		
	minutes += 1


func _on_player_tree_entered():
	_changeLevelLable("Endless Mode \n Start!")


func _on_boss_area_body_entered(body):
	if body is Enemy_Dreadnought:
		body.healerSpawning = true
	if body is Enemy_Boss_1 or body is Enemy_Torpedo:
		body.stop = true

func _on_despawn_area_body_entered(body):
	if body is Enemy and body.despawning == true:
		body.queue_free()

# Makes the mode Dynamic
func _on_shuffle_timeout():
	#print("shuffle!")
	EndlessHandler.set_random_number() # Randomizes 
	EndlessHandler.waveChooser() # Chooses a new wave of enemies and enemies
	ScoreHandler.score_multiplier += 0.01 
	EndlessHandler.set_shuffle_time(shuffle) # Randomizes the shuffle time
