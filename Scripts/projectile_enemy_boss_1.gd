extends EnemyProjectile

func _ready():
	damage = 4
	speed = 400
	

func _physics_process(delta):
	position.y = position.y + (speed * delta)
	
func _on_body_entered(body):
	if body is Player:
		BehaviourFuncs.take_damage(damage, body.health, body, false)
		queue_free()
	else:
		queue_free()
