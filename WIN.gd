extends Node

const Loon=preload("res://Loon.tscn")
const Message_typing=preload("res://Message_typing.tscn")

var finish=false

func _ready():
	var message_typing=Message_typing.instance()
	var main=get_tree().current_scene
	message_typing.messages=["(Luna insidiosa)","Now...",
	"When the Great Old One is defeated...",
	"You must forget everything!","Fear not, my child.",
	"You have served us well. ","..."]
	message_typing.read_time=3
	main.add_child(message_typing)
	
func _process(delta):
	if Input.is_action_just_pressed("ui_accept") && !finish:
		finish=true
		get_tree().change_scene("res://StartMenu.tscn")
	
func _on_message_is_written():
	var main=get_tree().current_scene
	var loon=Loon.instance()
	main.add_child(loon)
	yield($Loon,"tree_exited")		#again I know looks obscure but ...
	set_process(true)
	
