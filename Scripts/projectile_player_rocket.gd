extends Projectile

@onready var aoe = $AOE
@export var boom : PackedScene

func _ready():
	damage = 5
	speed = 350

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_toward(position.y, position.y - 5, delta)

func _on_body_entered(body):
	if body is Enemy:
		var boom_insta = boom.instantiate()
		boom_insta.position = global_position - Vector2(0.0, 100.0)
		add_sibling(boom_insta)
		BehaviourFuncs.take_damage(damage, body.health, body, true)
		var enemies_in_range = aoe.get_overlapping_bodies()
		BehaviourFuncs.aoe_damage(enemies_in_range, damage)
		queue_free()
	else:
		queue_free()
