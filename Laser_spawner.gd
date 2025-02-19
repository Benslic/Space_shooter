extends Node2D

const Laser_Beam=preload("res://Laser_Beam.tscn")
const Prepare_Laser=preload("res://Prepare_Laser.tscn")

var laser_notification_array=[]
var laser_beams_array=[]

var hard="hard"
var easy="easy"
var special="special"
var super_special="super_special"

var current_difficulty=easy

var current_config=[1,2,4,6]

var rapid_mode=false



func _ready():
	randomize()
	$Next_attack.start(5)

func get_spawn_point(var n=1):
	if n<1 || n>8:
		return $SpawnPoints.get_children()[4].global_position
	return $SpawnPoints.get_children()[n-1].global_position


func spawn_lasers(): # spawns lasers at certain points from 1-8
	$Attack_sound.play()
	#$Attack_sound_loop_timer.start(2.4)
	for spwn in current_config:
		var laser_beam=Laser_Beam.instance()
		laser_beams_array.push_back(laser_beam)
		laser_beam.global_position=get_spawn_point(spwn)+Vector2(0,-90)
		add_child(laser_beam)


func set_up_config():	#set up random attacks according to difficulty level
	match current_difficulty:
		easy:
			current_config.clear()
			var t=4
			while(t):
				var add=randi()%8+1
				if !current_config.has(add):
					current_config.push_back(add)
					t-=1
		hard:
			current_config.clear()
			current_config=[1,2,3,4,5,6,7,8]
		special:
			current_config.clear()
			current_config=[1,7,8]
		super_special:
			current_config.clear()
			current_config=[1,2,7,8]
	prepare_lasers() 
	
	
func prepare_lasers():
	$Warning_sound.play()
	for n in current_config:
		var laser_notification=Prepare_Laser.instance()
		laser_notification_array.push_back(laser_notification)
		laser_notification.global_position=get_spawn_point(n)
		add_child(laser_notification)
	$prepare_timer.start(2.8)
	

func _on_prepare_timer_timeout():
	for ln in laser_notification_array:
		ln.queue_free()
	laser_notification_array.clear()
	spawn_lasers()
	$attack_timer.start(2)
	
func _on_attack_timer_timeout():
	$Attack_sound.stop()
	#$Attack_loop.stop()
	for lb in laser_beams_array:
		lb.queue_free()
	laser_beams_array.clear()
	
func _on_Attack_sound_loop_timer_timeout():
	$Attack_loop.play()

func _on_Next_attack_timeout():
	if get_parent().stop_every_attack:
		$Next_attack.start(6)
	else:
		set_up_config()
		if (rapid_mode):
			$Next_attack.start(rand_range(5,16))
		else:
			$Next_attack.start(rand_range(10,30))
