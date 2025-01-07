extends Button

@export var action : String 
@onready var options_controls = $"../../../../../../.."

func _init():
	toggle_mode = true
	
func _ready():
	set_process_unhandled_key_input(false)
	
func _toggled(button_pressed):
	set_process_unhandled_key_input(button_pressed)
	if button_pressed:
		text = "..."
		
func _unhandled_key_input(event):
	if event.pressed:
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, event)
		button_pressed = false
		release_focus()
		_updateButtonKeyPressed()
		
func _updateButtonKeyPressed():
	text = InputMap.action_get_events(action)[0].as_text()
