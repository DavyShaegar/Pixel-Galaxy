extends EnemyProjectile
class_name rocket_enemy

@onready var aoe = $AOE
@export var boom : PackedScene

func _ready():
	randomize()
	damage = 4
	speed = 135

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y = position.y + (speed * delta)

func explode(body):
	var boom_insta = boom.instantiate()
	boom_insta.position = global_position + Vector2(0.0, -30.0)
	add_sibling(boom_insta)
	
	if body is Player:
		BehaviourFuncs.take_damage(damage, body.health, body, false)
	else:
		GameSounds.low_boom.pitch_scale = randf_range(0.5, 1.5)
		GameSounds.low_boom.play()	
		
	var enemies_in_range = aoe.get_overlapping_bodies()
	BehaviourFuncs.aoe_damage(enemies_in_range, damage)
	queue_free()
	
func _on_body_entered(body):
	explode(body)
