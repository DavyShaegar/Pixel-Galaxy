class_name Player
extends CharacterBody2D

@onready var shotcooldown = $ShotCooldown
@onready var progress_bar = $CooldownBar
@onready var weapons_sprite = $Weapons_Sprite
@onready var ship_sprite = $Ship_Sprite
@onready var collision = $CollisionShape2D
@onready var invul_sprite = $Invul_Sprite

# Pickup GUI
@onready var pickup_timer = $PickupTimer
@onready var pickup_timer_label = $PickupTimerGUI/PickupTimer_Label
@onready var pickup_timer_gui = $PickupTimerGUI
@onready var pickup_timer_bar = $PickupTimerGUI/PickupTimer_Bar
@onready var powerup_name = $PickupTimerGUI/Powerup_Name
@onready var invul_timer = $InvulTimer

@export_category("Variables")
@export var speed : int = 280
@export var canShot : bool = true
@export var shotdelay : float = 0.4
@export var health : int = 4
@export var invulnerable : bool = false

@export_category("States")
@export var current_base_state = base_states.idle
@export var current_weapon_state = weapon_type_states.base

@export_category("Pause Menu")
@export var pause_menu : PackedScene

@onready var got_hit : int
@onready var no_input : bool = false

# Invul shield sprite flickering
var rng = RandomNumberGenerator.new()
@onready var invulColor : Color = Color(1.0, 1.0, 1.0, 0.8)

enum base_states {idle, move, shoot, hit, death}
enum weapon_type_states {base, mg, zapper, rocket} # add more

func checkdeath() -> void:
	updateHealthCounter()
	if current_base_state == base_states.death:
		no_input = true
		weapons_sprite.play("null")
		ship_sprite.play("death")
		if collision != null:
			collision.queue_free()
			progress_bar.queue_free()
			$CooldownBarBorder.queue_free()

func get_weapon(weapons, current_weapon) -> String:
	return weapons.find_key(current_weapon)

func _got_hit() -> int:
	
	ScoreHandler.hits_count += 1

	if health == 3:
		return 1
	elif health == 2:
		return 2
	elif health == 1:
		return 3
	elif health <= 0:
		return -1
	else:
		return 0

func _animation():
	if current_base_state == base_states.shoot:
		weapons_sprite.play(get_weapon(weapon_type_states, current_weapon_state)+"_shoot")
	elif current_base_state == base_states.hit:
		got_hit = _got_hit()
		ship_sprite.frame = got_hit

func _movement():
	if !Input.is_anything_pressed(): 
		current_base_state = base_states.idle
		return
	else:
		current_base_state = base_states.move
		velocity.x = Input.get_axis("Left", "Right")
		velocity.y = Input.get_axis("Up", "Down")
		velocity = velocity.normalized() * speed
		move_and_slide()
	
func _shooting():
	
	shotcooldown.wait_time = shotdelay
	if Input.is_action_just_pressed("Shoot") && canShot == true:
		ShotsHandler.on_player_shoot($".")
		current_base_state = base_states.shoot
		shotcooldown.start()
		canShot = false
	progress_bar.value =  ((shotcooldown.wait_time - shotcooldown.time_left) / shotcooldown.wait_time) * 100
	
func _paused():
	if Input.is_action_just_pressed("Pause"):
		get_tree().paused = true
		
		var pausemenu_insta = pause_menu.instantiate()
		pausemenu_insta.position =  get_viewport_rect().size / 2
		add_sibling(pausemenu_insta)
		
func updateHealthCounter():
	if current_base_state == base_states.hit or current_base_state == base_states.death:
		var health_counter = $"../CanvasLayer2/HealthBox/Health"
		match health:
			4:
				health_counter.size.x = 128
			3:
				health_counter.size.x = 96
			2:
				health_counter.size.x = 64
			1:
				health_counter.size.x = 32
			0:
				health_counter.size.x = 0

func _updatePickupTimer(powerup):
	if! pickup_timer.is_stopped():
		powerup_name. text = powerup
		pickup_timer_label.text = str(int(pickup_timer.time_left))
		pickup_timer_bar.value =  pickup_timer.time_left
		pickup_timer_gui.visible = true
	else:
		pickup_timer_gui.visible = false

func _updateInvulSprite(newcolor: Color):
	var randAlpha = rng.randf_range(-0.2, 0.2)
	newcolor += Color(0.0, 0.0, 0.0, randAlpha)
	
	if newcolor.a > 0.8:
		newcolor.a = 0.75
	elif newcolor.a < 0.1:
		newcolor.a = 0.2
		
	invul_sprite.set_modulate(newcolor)
	invulColor = newcolor
	
func _process(_delta):
	if no_input == true: return
	checkdeath()
	_paused()
	_animation()
	_movement()
	_shooting()
	
	## DEBUG ##
	if Input.is_action_just_pressed("DEBUG_ChangeLevel"):
		if LevelHandler.current_level == "Level_01":
			print("Ending level 1...")
			BehaviourFuncs.end_level_01()
		elif LevelHandler.current_level == "Level_02":
			print("Ending level 2...")
			BehaviourFuncs.end_level_02()
		
	_updatePickupTimer(get_weapon(weapon_type_states, current_weapon_state))
	if invulnerable == true and invul_timer.time_left < 5:
		_updateInvulSprite(invulColor)
		

func _on_shot_cooldown_timeout(): 
	shotcooldown.stop()
	if current_weapon_state != weapon_type_states.rocket:
		canShot = true


func _on_ship_sprite_animation_finished():
	if ship_sprite.animation == "death":
		# Adds the death screen
		var death_screen : PackedScene = load("res://Scenes/Instances/death_screen.tscn")
		var death_screen_insta = death_screen.instantiate()
		death_screen_insta.position = get_viewport_rect().size / 2
		add_sibling(death_screen_insta)
		
		# Saves the score
		BehaviourFuncs.save_score()
		
		# Deletes the player
		queue_free()


func _on_pickup_timer_timeout():
	#print("No more powerup!")
	# Weapons
	current_weapon_state = weapon_type_states.base
	shotdelay = 0.4
	weapons_sprite.set_animation("base_shoot")
	pickup_timer.stop()


func _on_invul_timer_timeout():
	invulnerable = false
	invul_sprite.visible = false
	invul_sprite.set_modulate(Color(1.0, 1.0, 1.0, 0.8))
	GameSounds.invul_down.stop()
