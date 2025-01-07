class_name EnemyProjectile_Heavy
extends EnemyProjectile
# Called when the node enters the scene tree for the first time.
func _ready():
	damage = 2
	speed = 400

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position.y = position.y + (speed * delta)

func _on_body_entered(body):
	if body is Player:
		BehaviourFuncs.take_damage(damage, body.health, body, false)
		queue_free()
	else:
		queue_free()
