extends Node2D

const Special_enemy=preload("res://Special_enemy.tscn")

func _ready():
	pass

func go():
	var main=get_tree().current_scene
	var special_enemy=Special_enemy.instance()
	main.add_child(special_enemy)
	special_enemy.position=global_position
	queue_free()
