extends level_handler
class_name level_2

@onready var first_wave = $Wave1_Start
@onready var fighters_rando_1 = $Wave1_Start/FighterDelay
@onready var wv_1_fighter_stop = $Wave1_Start/WV_1_FighterStop
@onready var heavy_delay = $Wave1_Start/HeavyDelay
@onready var heavy_fighter_row_delay = $Wave1_Start/Heavy_FighterRowDelay
@onready var wv_1_heavy_stop = $Wave1_Start/WV_1HeavyStop

@onready var wave_2_start = $Wave2_Start
@onready var HeavyDelay_2 = $Wave2_Start/HeavyDelay_2
@onready var healer_delay = $Wave2_Start/HealerDelay
@onready var wv_2_fighter_healer_stop = $Wave2_Start/WV_2FighterHealerStop

@onready var wave_3_start = $Wave3_Start
@onready var heavy_row = $Wave3_Start/Heavy_row
@onready var healer_delay_2 = $Wave3_Start/Healer_delay_2
@onready var boss_start = $Wave3_Start/Boss_start
@onready var boss_minions_fighter = $Wave3_Start/Boss_minions_Fighter

func _process(_delta):
	pass

#region Wave1
func _on_wave_1_start_timeout(): 
	# Spawn Positions
	posmark = get_node("/root/MainGame/SpawnArea/Marker_positive").global_position
	negmark = get_node("/root/MainGame/SpawnArea/Marker_negative").global_position
	
	# Sets the new level and wave
	wave_label = get_node("/root/MainGame/CanvasLayer2/Wave")
	wave_label.text = "1" 
	ScoreHandler.score_multiplier = 1.5
	
	# Base enemy random spawn
	fighters_rando_1.start()
	wv_1_fighter_stop.start()

func _on_fighter_delay_timeout():
	RandoSpawn(base_enemy)
	
func _on_wv_1_fighter_stop_timeout():
	# Ends rando spawn
	fighters_rando_1.stop()
	
	# Starts heavy random e base rows
	heavy_delay.start()
	heavy_fighter_row_delay.start()
	wv_1_heavy_stop.start()
	
func _on_heavy_delay_timeout():
	RandoSpawn(heavy_enemy)
	
func _on_heavy_fighter_row_delay_timeout():
	RowSpawn(base_enemy)

func _on_wv_1_heavy_stop_timeout():
	# Ends the wave
	heavy_delay.stop()
	heavy_fighter_row_delay.stop()
	wave_label.text = "2"
	wave_2_start.start()
#endregion

#region Wave 2

func _on_wave_2_start_timeout():
	# Starts rando and healer
	HeavyDelay_2.start()
	healer_delay.start()
	wv_2_fighter_healer_stop.start()

func _on_fighter_delay_2_timeout():
	RandoSpawn(heavy_enemy)

func _on_healer_delay_timeout():
	RandoSpawn(Healer)

func _on_wv_2_fighter_healer_stop_timeout():
	# ends the rando and healer onslaught
	HeavyDelay_2.stop()
	healer_delay.stop()
	# Starts the final wave
	wave_3_start.start()
#endregion

#region Wave 3

# Heavy row with rando healers
func _on_wave_3_start_timeout():
	heavy_row.start()
	healer_delay_2.start()
	# Bossfight countdown
	boss_start.start()
func _on_heavy_row_timeout():
	RowSpawn(Enemy_Heavy)
func _on_healer_delay_2_timeout():
	RandoSpawn(Enemy_Healer)

# Rocket boss with fighter support
func _on_boss_start_timeout():
	BossSpawn(Enemy_Rocket)
	boss_minions_fighter.start()
func _on_boss_minions_fighter_timeout():
	RandoSpawn(Enemy)
#endregion
