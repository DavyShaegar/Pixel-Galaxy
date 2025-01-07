extends level_handler
class_name level_1

@onready var first_wave = $FirstWave
@onready var second_wave = $SecondWave

# First Wave
@onready var fighters_rando = $FirstWave/FightersRando
@onready var fighters_rows = $FirstWave/FightersRows
@onready var fighter_rows_wait_rows = $FirstWave/FightersRows/FighterRows_WaitRows
@onready var fighter_rows_stop = $FirstWave/FightersRows/FighterRows_Stop
@onready var wave1_stop = $"FirstWave/1STOP"

# 2ND Wave
@onready var wave_2_rando_stop = $SecondWave/Wave2Rando_Stop
@onready var heavy_spawn = $SecondWave/HeavySpawn
@onready var fighter_rows_2 = $SecondWave/FighterRows2
@onready var fighter_rows_wait_rows_2 = $SecondWave/FighterRows2/FighterRows_WaitRows2
@onready var fighter_rows_stop_2 = $SecondWave/FighterRows2/FighterRows_Stop2

# 3RD Wave
@onready var third_wave = $ThirdWave
@onready var boss_spawn = $ThirdWave/BossSpawn

func _process(_delta):
	pass

# Gets the position nodes and starts the wave
func _on_first_wave_timeout():
	# Spawn Positions
	posmark = get_node("/root/MainGame/SpawnArea/Marker_positive").global_position
	negmark = get_node("/root/MainGame/SpawnArea/Marker_negative").global_position
	firstWave()
	

#region WAVE 1

# First Wave Start
func firstWave():
	wave_label = get_node("/root/MainGame/CanvasLayer2/Wave")
	wave_label.text = "1"
	fighters_rando.start()
	fighters_rows.start()

# 1 - Spawns random positioned enemies
func _on_fighters_rando_timeout():
	RandoSpawn(base_enemy)

# 2 - Random Spawn stop - Rows start
func _on_fighters_rows_timeout():
	fighters_rando.stop()
	fighter_rows_wait_rows.start()
	fighter_rows_stop.start()

# 3 - Sets the distance between rows
func _on_fighter_rows_wait_rows_timeout():
	RowSpawn(base_enemy)

# 4 - Stop Rows Restart Random
func _on_fighter_rows_stop_timeout():
	fighters_rando.wait_time = 0.8
	fighters_rando.start()
	fighter_rows_wait_rows.stop()
	wave1_stop.start()

# Finishes the first wave and stars the second
func _on_stop_timeout():
	Current_Wave = 2
	wave_label.text = "2"
	fighters_rando.stop()
	heavy_spawn.start()
	wave_2_rando_stop.start()
	fighter_rows_2.start()
	
#endregion

#region WAVE 2
# Stops the heavy wave
func _on_wave_2_rando_stop_timeout():
	heavy_spawn.stop()

# Starts spawning
func _on_heavy_spawn_timeout():
	RandoSpawn(heavy_enemy)

func _on_fighter_rows_2_timeout():
	fighter_rows_wait_rows_2.start()
	fighter_rows_stop_2.start()

func _on_fighter_rows_wait_rows_2_timeout():
	RowSpawn(base_enemy)
	fighter_rows_wait_rows.stop()

func _on_fighter_rows_stop_2_timeout():
	fighter_rows_wait_rows_2.stop()
	Current_Wave = 3
	wave_label.text = "3"
	third_wave.start()
	boss_spawn.start()
	#endregion

func _on_third_wave_timeout():
	RandoSpawn(base_enemy)

func _on_boss_spawn_timeout():
	BossSpawn(boss)
