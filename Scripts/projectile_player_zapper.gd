extends Projectile
@onready var border_touched = false
@onready var longZap : Node
@onready var zapcount : int = 0
@onready var nextZapPos : Vector2
@onready var zap_reset_timer = $ZapResetTimer

func _resetZap() -> void:
	var allZaps : Array = self.get_parent().get_children()
	zap_reset_timer.start()
	await zap_reset_timer.timeout
	for zap in allZaps:
		
		if zap == null: continue
		
		if zap is Projectile:
			zap.queue_free()
			
# Called when the node enters the scene tree for the first time.
func _ready():
	speed = 0
	damage = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):

	if border_touched == false && self.name == "ProjectilePlayerZapper":
		if zapcount == 0:
			longZap = self.duplicate()
		else:
			longZap = longZap.duplicate()
		nextZapPos = longZap.global_position + Vector2(0, -35)
		longZap.position = nextZapPos

		self.get_parent().add_child(longZap)
		zapcount +=1

func _on_body_entered(body):
	if body is Enemy:
		BehaviourFuncs.take_damage(damage, body.health, body, true)
	else:
		_resetZap()
		get_parent().get_node("ProjectilePlayerZapper").border_touched = true

# Restarts zap duplication if not colliding with border anymore?
func _on_body_exited(body):
	if !body is Enemy:
		border_touched = false
