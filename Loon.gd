extends Node


func _ready():
	$Tween.interpolate_property($ColorRect,"color",$ColorRect.color,Color.webmaroon,0.5,Tween.TRANS_LINEAR)
	$Tween.start()
	yield(get_tree().create_timer(0.5),"timeout")
	$Tween.interpolate_property($ColorRect,"color",$ColorRect.color,Color.black,1,Tween.TRANS_LINEAR)
	$Tween.start()
	yield(get_tree().create_timer(1),"timeout")
	queue_free()
	
