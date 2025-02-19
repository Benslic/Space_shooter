extends Node

var boss_fight=false


var score=0 setget set_score
onready var ScoreLabel=$Score

const Player= preload("res://Ship.tscn")
const Stage_0=preload("res://Stage_0.tscn")

signal asteroids
signal lasers
signal black_hole

var player_is_dead=false

var asteroids_added=false
var stage_0_added=false


func set_score(value):
	score=value
	check_key_points()
	update_score_label()	

#func _on_Enemy_score_up():
	#self.score+=10

func update_score_label():
	ScoreLabel.text="Score= "+str(score) 

func update_save_data():
	var save_data=SaveAndLoad.load_data_from_file()
	if score>save_data.HIGHSCORE:
		save_data.HIGHSCORE=score
		SaveAndLoad.save_data_to_file(save_data)
		
func check_key_points():
	if score>80 && !asteroids_added:
		asteroids_added=true
		emit_signal("asteroids")
	if score>=250 &&!stage_0_added:
		stage_0_added=true
		set_up_for_stage_0()

func set_up_for_stage_0():
	$EnemySpawner.queue_free()
	boss_fight=true
	$main_music.stop()
	yield(get_tree().create_timer(2),"timeout")		#time to clear the are from enemies
	$Stars.set_emitting(false)
	add_child(Stage_0.instance())

	

func _on_Player_player_death():
	player_is_dead=true
	$Death_sound.play()
	update_save_data()
	yield(get_tree().create_timer(2),"timeout")
	get_tree().change_scene("res://GameOver.tscn")
