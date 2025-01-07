class_name Pickup
extends Area2D

@onready var border= $AnimatedSprite2D

func _ready():
	border.play("default")

func _process(_delta):
	position.y = position.y + 1

func _on_body_entered(body):
	if body is Player:

		var object_type : String = get_child(0).name
		if object_type == "Health" or object_type == "Invulnerability" or object_type == "Bomb":
			
			match object_type:
				"Health":
					GameSounds.heal_player.play()
					BehaviourFuncs.heal_object(body, self)
				"Invulnerability":
					GameSounds.invul_up.play()
					BehaviourFuncs.add_invul(body)
					GameSounds.invul_down_playLoop()
				"Bomb":
					GameSounds.pickup_nuclear.play()
					if LevelHandler.get_current_level() != null:
						ShotsHandler.bomb_killAll(LevelHandler.get_current_level())
					else:
						ShotsHandler.bomb_killAll(get_node("/root/EndlessHandler"))
		else:
			GameSounds.pickup_weapon.play()
			BehaviourFuncs.ChangeWeapon(self, body)
			
		queue_free()
