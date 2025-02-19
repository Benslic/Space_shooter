extends Node


onready var highscore=$Highscore



const Loon=preload("res://Loon.tscn")
const Message_typing=preload("res://Message_typing.tscn")


var loon_is_shown=false




func _process(delta):
	if Input.is_action_pressed("g") && Input.is_action_pressed("o") && !loon_is_shown:
		loon_is_shown=true
		show_loon()
	if Input.is_action_just_released("ui_accept"):
		$Help_label.text="try go "+$Help_label.text
func show_loon():
	if $Message_typing:
		$Message_typing.queue_free()

	var main=get_tree().current_scene
	var loon=Loon.instance()
	main.add_child(loon)
	#loon.get_node("ColorRect").set_position(Vector2(130,30))
	yield($Loon,"tree_exited")
	if SaveAndLoad.THE_OLD_GOD:
		get_tree().change_scene("res://Final_stage.tscn")
	else:
		get_tree().change_scene("res://World.tscn")

func _ready():
	var message_typing=Message_typing.instance()
	var main=get_tree().current_scene
	randomize()
	var n= randi()%3
	if n==0:
		message_typing.messages=["Do not worry my child.","We pray for your soul.","More talk to be had?"]
	elif n==1:
		message_typing.messages=["Yes, WE see...","WE suppose that's natural.","If you ever change your mind...","You know where IT will be. "]
	else:
		message_typing.messages=["Oh, dear child!","Put an end to our suffering","...","Be aware of Ancients' power","Be aware!"]
	main.add_child(message_typing)
	

func set_highscore_label():
	var save_data=SaveAndLoad.load_data_from_file()
	highscore.text=str(save_data.HIGHSCORE)+"/250"

func _on_message_is_written():
	set_highscore_label()
	
	#print("We are here")
	
