extends Node2D

const Enemy=preload("res://Enemy.tscn")

onready var spawnPoints=$SpawnPoints

var go_is_shown=false



func get_spawn_position():
	var points=spawnPoints.get_children()
	points.shuffle()
	return points[0].global_position
	
func spawn_enemy():
	var spawn_position=get_spawn_position()
	var enemy =Enemy.instance()
	var main=get_tree().current_scene
	main.add_child(enemy)
	enemy.global_position=spawn_position

func _ready():
	randomize()


func _on_Timer_timeout():
	
	if !go_is_shown:
		var main=get_tree().current_scene
		main.get_node("Start_label").queue_free()
		go_is_shown=true
	spawn_enemy()


func _on_Get_ready_timeout():
	var main=get_tree().current_scene
	#var start_timer=main.get_node("Start_label")
	#start_timer.text="GO!!!"
	main.get_node("Start_label").text="GO!!!"
	$Timer.start(1)
	$Get_ready.queue_free()
