extends Enemy
class_name Enemy_Torpedo
@onready var player_detection = $Area2D
@onready var stop : bool = false

func _ready():
	health = 75
	speed = 15
	shoot_delay = 2.5
	base_score_points = 500

func _process(delta):
	if death() == true:
		death()
		return
	if stop != true:
		enemy_move_collide(delta)
	if player_detection.has_overlapping_bodies() == true and cooldown == false: 
		enemy_shoot(shoot_delay)
		
func _on_animated_sprite_2d_animation_finished():
	if current_base_state == base_states.death:
		
		# Ends the level if in story mode 
		if LevelHandler.get_current_level() != null: 
			BehaviourFuncs.end_level_02()
		else:
			EndlessHandler.boss_present = false
		queue_free()
		
func _on_shotcooldown_timeout():
	cooldown = false
	_shotcooldown.stop()
