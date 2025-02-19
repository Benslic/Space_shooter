extends Node

const Stage=preload("res://Stage_1.tscn")

var stop_every_attack=false

var second_boss_is_dead=false
var first_boss_is_dead=false

var player_is_dead=false

var ultra_rage_anim_is_played=false

var boss_fight=false		#just a trick so I could use Asteroids scene without changes

func _ready():
	SaveAndLoad.THE_OLD_GOD=true
	var stage=Stage.instance()
	get_tree().current_scene.add_child(stage)
	stage.global_position=Vector2(250,61)

func _on_Player_player_death():
	player_is_dead=true
	$Death_sound.play()
	if !ultra_rage_anim_is_played:
		get_node("1StageBackground/Transition").play("player_death")
		yield(get_tree().create_timer(4),"timeout")
		switch_to_game_over()
	else:
		get_node("1StageBackground/Transition").play("player_death_after_ultra_rage")
		yield(get_tree().create_timer(4),"timeout")
		switch_to_game_over()
func switch_to_game_over():
	get_tree().change_scene("res://GameOver.tscn")
	
func the_end():
	get_node("1StageBackground/Transition").play("the_end")
	yield(get_tree().create_timer(11),"timeout")
	switch_to_win()

func switch_to_win():
	get_tree().change_scene("res://WIN.tscn")
