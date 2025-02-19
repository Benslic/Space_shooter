extends Node

signal message_is_written

var messages = [
	"You have failed...", 
	"We are sending your clone to finish THE MISSION!"
]

var typing_speed = 0.08
var read_time = 2

var current_message = 0
var display = ""
var current_char = 0


func _ready():
	start_dialogue()
	
func start_dialogue():
	current_message = 0
	display = ""
	current_char = 0
	$Typing_sound.play()
	$next_char.set_wait_time(typing_speed)
	$next_char.start()

func stop_dialogue():
	queue_free()
	

func _on_next_char_timeout():
	if (current_char < len(messages[current_message])):
		var next_char = messages[current_message][current_char]
		display += next_char
		
		$Message.text = display
		current_char += 1
	else:
		$next_char.stop()
		$next_message.one_shot = true
		$next_message.set_wait_time(read_time)
		$Typing_sound.stop()
		$next_message.start()

func _on_next_message_timeout():
	
	if (current_message == len(messages) - 1):
		stop_dialogue()
	else: 
		current_message += 1
		display = ""
		current_char = 0
		$next_char.start()
		$Typing_sound.play()

func _exit_tree():
	var main=get_tree().current_scene
	connect("message_is_written",self.get_parent(),"_on_message_is_written")
	emit_signal("message_is_written")
