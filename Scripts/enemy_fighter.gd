class_name Enemy
extends CharacterBody2D

@onready var _raycast = $RayCast2D
@onready var _shotcooldown = $shotcooldown
@onready var _animation = $AnimatedSprite2D
@onready var collision = $CollisionShape2D

@export_category("Base Enemy Stats")
@export var despawning : bool = true
@export var health : int = 1
@export var speed : int = 100
@export var shoot_delay : float = 1.0
@export var base_score_points : int = 1
@export var invulnerable : bool = false

@onready var cooldown : bool = false

enum base_states {idle, shoot, hit, death}
@onready var current_base_state = base_states.idle

func death():
	if current_base_state == base_states.death:
		_animation.play("death")
		return true

func enemy_move_collide(delta):
	velocity.y = speed
	var ship_crash = move_and_collide(velocity * delta)
	if ship_crash != null:
		var collider = ship_crash.get_collider()
		if collider.invulnerable == true:
			GameSounds.low_boom.play()
			queue_free()
			return
			
		collider.health = 0
		collider.current_base_state = collider.base_states.death
		GameSounds.low_boom.play()
		queue_free()
		
func enemy_shoot(ShotDelay : float):
	cooldown = true
	_shotcooldown.start()
	await get_tree().create_timer(ShotDelay).timeout
	
	# Rocket boss has a cone shaped area of detection
	if self is Enemy_Torpedo:
		ShotsHandler.enemyrocket_shoot(self)
		return

	if _raycast.is_colliding():
		ShotsHandler.enemybase_shoot(self)
	elif !_raycast.is_colliding():
		GameSounds.heavy_charge.stop()

func _ready():
	_shotcooldown.wait_time = shoot_delay

func _process(delta):
	if death() == true: 
		death()
		return
	
	enemy_move_collide(delta)
	if _raycast.is_colliding() and cooldown == false: enemy_shoot(0.3)


func _on_shotcooldown_timeout():
	cooldown = false
	_shotcooldown.stop()


func _on_animated_sprite_2d_animation_finished():
	if current_base_state == base_states.death:
		queue_free()
