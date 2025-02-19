extends Node2D


func _ready():
	$Label.text="x"+str(get_tree().current_scene.get_node("Player").player_hp)

func update_info(var n):
	$Label.text="x"+str(n) 
