extends level_handler
class_name level_3

@onready var wave_1_start = $Wave1_Start
@onready var fighter_rando_1 = $Wave1_Start/Fighter_rando_1
@onready var fighter_row_1 = $Wave1_Start/Fighter_Row_1
@onready var heavy_rando_lowcount_1 = $Wave1_Start/Heavy_Rando_lowcount_1
@onready var healer_rando_1 = $Wave1_Start/Healer_rando_1
@onready var endwave = $Wave1_Start/endwave


@onready var wave_2_start = $Wave2_start
@onready var fighter_rando_2 = $Wave2_start/Fighter_rando_2
@onready var heavy_row_1 = $Wave2_start/Heavy_Row_1
@onready var endwave_2 = $Wave2_start/endwave_2

@onready var wave_3_final_boss = $Wave3_FinalBoss

@export var final_Boss : PackedScene
#region Wave_1

func _on_wave_1_start_timeout():
	fighter_rando_1.start()
	fighter_row_1.start()
	heavy_rando_lowcount_1.start()
	healer_rando_1.start()
	endwave.start()

func _on_fighter_rando_1_timeout():
	RandoSpawn(base_enemy)

func _on_fighter_row_1_timeout():
	RowSpawn(base_enemy)

func _on_heavy_rando_lowcount_1_timeout():
	RandoSpawn(heavy_enemy)

func _on_healer_rando_1_timeout():
	RandoSpawn(Healer)
	
func _on_endwave_timeout():
	fighter_rando_1.stop()
	fighter_row_1.stop()
	heavy_rando_lowcount_1.stop()
	healer_rando_1.stop()
	wave_2_start.start()
#endregion

#region Wave 2

func _on_wave_2_start_timeout():
	fighter_rando_2.start()
	heavy_row_1.start()
	endwave_2.start()
	
func _on_fighter_rando_2_timeout():
	RandoSpawn(base_enemy)

func _on_heavy_row_1_timeout():
	RowSpawn(heavy_enemy)

func _on_endwave_2_timeout():
	fighter_rando_2.stop()
	heavy_row_1.stop()
	wave_3_final_boss.start()

#endregion

# Finish line
func _on_wave_3_final_boss_timeout():
	BossSpawn(final_Boss)
