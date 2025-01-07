class_name Projectile
extends Area2D
@export_category("Projectile stats")
@export var damage : int = 1
@export var speed : int = 350

func _physics_process(delta):
	position.y = position.y - (speed * delta)
	
func _on_body_entered(body):
	#print(body.get_class())
	if body is Enemy:
		BehaviourFuncs.take_damage(damage, body.health, body, true)
		queue_free()
	else:
		queue_free()
