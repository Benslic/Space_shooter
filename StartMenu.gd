extends Node

	
var counter=2

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		$Try_it.start(0.3)
		$Timer_to_play.start(3)
		
	if Input.is_action_just_released("ui_accept"):
		counter-=1
		$Loon.stop()
		$Timer_to_play.stop()
		$Try_it.stop()
		$SpaceSound.play()
		if counter>-2 && counter<=0:
			$CenterContainer/Label.text=$CenterContainer/Label.text + "\nHOLD IT"
		elif counter<=-2 && counter>-4:
			$CenterContainer/Label.text="hold it for few seconds"
		elif counter<=-4 && counter>=-6:
			$CenterContainer/Label.text="PRESS ENTER and HOLD IT UNTIL YOU WIN!!!"
		elif counter<-6:
			$CenterContainer/Label.text="..."
	
func _on_Try_it_timeout():
	$Loon.play()

func _on_Timer_to_play_timeout():
	get_tree().change_scene("res://World.tscn")


func _on_Cheat_codes_cheat_detected(string):
	if string=="go":
		get_tree().change_scene("res://World.tscn")
	elif string=="exit":
		queue_free()
