extends Node2D


const Asteroid=preload("res://Asteroid.tscn")

onready var spawnPoints=$SpawnPoints
var total_attacks
var sec_before_next_wave


func get_random_velocity():
	return Vector2(rand_range(-150,-50),rand_range(50,120))


func get_spawn_position():
	var points=spawnPoints.get_children()
	points.shuffle()
	return points[0].global_position
	
func spawn_enemy():
	var spawn_position=get_spawn_position()
	var asteroid =Asteroid.instance()
	asteroid.set_linear_velocity(get_random_velocity())
	var main=get_tree().current_scene
	main.add_child(asteroid)
	asteroid.global_position=spawn_position

func _ready():
	randomize()
	$Next_wave.start(rand_range(15,30))
	set_up()


func set_up():
	if get_parent().boss_fight:
		queue_free()
	total_attacks=randi()%7+2
	print("Total attacks: ",total_attacks)
	$Warning_sound.play()
	$Timer.start(2.6)


func _on_Timer_timeout():
	spawn_enemy()
	total_attacks-=1
	if(total_attacks>0) && !get_parent().boss_fight:
		$Timer.start(rand_range(1,3.8))
	elif get_parent().boss_fight:
		queue_free() 


func _on_Next_wave_timeout():
	set_up()
	$Next_wave.start(rand_range(15,25))
