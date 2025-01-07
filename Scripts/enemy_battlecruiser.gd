extends Enemy
class_name Enemy_Boss_1
@onready var stop : bool = false

@onready var boss_stop_left = $"../BossArea/Boss_Stop_Left"
@onready var boss_stop_middle = $"../BossArea/Boss_Stop_Middle"
@onready var boss_stop_right = $"../BossArea/Boss_Stop_Right"
@onready var movecooldown = $movecooldown
@onready var next_move : int
@onready var should_move : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	if LevelHandler.get_current_level() == null:
		boss_stop_left = get_node("/root/Endless/BossArea/Boss_Stop_Left")
		boss_stop_middle = get_node("/root/Endless/BossArea/Boss_Stop_Middle")
		boss_stop_right = get_node("/root/Endless/BossArea/Boss_Stop_Right")
	health = 30
	speed = 75
	base_score_points = 300
	shoot_delay = 1.2
	randomize()

func horizontal_random_movement(move):
	match move:
		1:
			position.x = move_toward(position.x, boss_stop_middle.position.x, speed * get_physics_process_delta_time())
		2:
			position.x = move_toward(position.x, boss_stop_left.position.x, speed * get_physics_process_delta_time())
		3:
			position.x = move_toward(position.x, boss_stop_right.position.x, speed * get_physics_process_delta_time())
	
	velocity.y = 0
	move_and_slide()
	
func boss_shoot(ShotDelay):
	cooldown = true
	_shotcooldown.start()
	await get_tree().create_timer(ShotDelay).timeout
	GameSounds.enemy_boss_01_shoot.play()
	ShotsHandler.enemybase_shoot(self)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if death() == true:
		death()
		return
		
	if stop != true:
		enemy_move_collide(delta)
	else:
		if should_move == true:
			horizontal_random_movement(next_move)
		
		if movecooldown.is_stopped():
			movecooldown.start()
			
		if cooldown == false:
			boss_shoot(shoot_delay)



func _on_animated_sprite_2d_animation_finished():
	if current_base_state == base_states.death:
		# Ends the level if in story mode 
		if LevelHandler.get_current_level() != null: 
			BehaviourFuncs.end_level_01()
		else:
			EndlessHandler.boss_present = false
		queue_free()
		
func _on_shotcooldown_timeout():
	cooldown = false
	_shotcooldown.stop()


func _on_movecooldown_timeout():
	next_move = randi_range(1,3)
	should_move = true
