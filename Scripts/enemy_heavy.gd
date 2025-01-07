extends Enemy
class_name Enemy_Heavy
# Called when the node enters the scene tree for the first time.
func _ready():

	health = 5
	speed = 50
	base_score_points = 5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if death() == true:
		death()
		return
	enemy_move_collide(delta)
	if _raycast.is_colliding() and cooldown == false: 
		GameSounds.heavy_charge.play()
		enemy_shoot(1.2)


func _on_animated_sprite_2d_animation_finished():
	if current_base_state == base_states.death:
		queue_free()
		
func _on_shotcooldown_timeout():
	cooldown = false
	_shotcooldown.stop()
