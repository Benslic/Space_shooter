extends Area2D

const Laser_Beam=preload("res://Laser_Beam.tscn")
const Special_Laser_Beam=preload("res://Special_Laser_Beam.tscn")
const Prepare_Laser=preload("res://Prepare_Laser.tscn")
const Ufo_laser=preload("res://Ufo_laser.tscn")
const Super_explosion=preload("res://Super_explosion.tscn")
const Life_Bar=preload("res://Second_boss_life_bar.tscn")
var life_bar_instance=Life_Bar.instance()
var life_bar=life_bar_instance.get_node("life")

var laser=Special_Laser_Beam.instance()

var prepare1
var prepare2

var speed1=PI/5
var speed2=PI/3.5
var current_speed=speed1


var rage_mode_on=false

var eye_vector=Vector2(-13,-22)


var max_hp=220
var hp=220

func _ready():
	set_process(false)
	randomize()

func _process(delta):
	laser.rotate(current_speed*delta)

func start_attack():
	get_parent().get_node("Enemies_Horde").start()
	
	$Warning_sound.play()
	prepare1=Prepare_Laser.instance()
	prepare2=Prepare_Laser.instance()
	add_child(prepare1)
	prepare1.global_position+=eye_vector
	add_child(prepare2)
	prepare2.global_position+=eye_vector
	prepare2.rotate(PI)
	$prepare_timer.start(2)
	
	
func _on_prepare_timer_timeout():
	get_parent().add_child(life_bar_instance)
	prepare1.queue_free()
	prepare2.queue_free()
	
	add_child(laser)
	laser.global_position=position+eye_vector
	$Attack_sound.play()
	$sound_loop.start(2.44)
	set_process(true)
	var main=get_tree().current_scene
	
	$change_rotation.start(rand_range(8,20))
	



func _on_change_rotation_timeout():
	if (randi()%2==0):
		current_speed*=-1
	$change_rotation.start(rand_range(6,13))


func _on_Stage_11_body_entered(body):
	if body.is_in_group("Cool_group"):
		print("-10")
		hp-=10
		life_bar.value-=10
		body.create_hit_effect()
		body.queue_free()
	elif body.is_in_group("deadly"):
		pass
	else:
		print("-1")
		hp-=1
		life_bar.value-=1
		body.create_hit_effect()
		body.queue_free()
	
	if hp<=max_hp/2 && !rage_mode_on:
		rage_mode_on=true
		rage_mode()
	if hp<=0:
		create_super_explosion()
		queue_free()


func _on_Shield_body_entered(body):
	if body.is_in_group("deadly"):
		pass
	elif body.is_in_group("Cool_group"):
		print("-20")
		hp-=20
		life_bar.value-=20
		body.create_hit_effect()
		body.queue_free()
	else:
		print("-0")
		counter_attack(body)
	
	if hp<=max_hp/2 && !rage_mode_on:
		rage_mode_on=true
		rage_mode()
	
	if hp<=0:
		create_super_explosion()
		get_parent().second_boss_is_dead=true
		queue_free()

func rage_mode():
	$rage_mode_sound.play()
	$stop_rage_mode_sound.start(3.8)
	set_process(false)
	
	
#	get_node("Collision").disabled=true
#	get_node("Shield/shield_collision").disabled=true
	$Collision.set_deferred("disabled", true)
	$Shield/shield_collision.set_deferred("disabled", true)
	

	yield(get_tree().create_timer(2),"timeout")
	current_speed=speed2
	$Collision.set_deferred("disabled", false)
	$Shield/shield_collision.set_deferred("disabled", false)
	set_process(true)

func counter_attack(var body):
	var main=get_tree().current_scene
	var ufo_laser=Ufo_laser.instance()
	ufo_laser.global_position=body.global_position
	body.queue_free()
	main.add_child(ufo_laser)

func create_super_explosion():
#	get_node("Collision").disabled=true
#	get_node("Shield/shield_collision").disabled=true

	$Collision.set_deferred("disabled", true)
	$Shield/shield_collision.set_deferred("disabled", true)
	
	set_process(false)
	var main=get_tree().current_scene
	var super_explosion=Super_explosion.instance()
	main.add_child(super_explosion)
	super_explosion.global_position=position


func _on_sound_loop_timeout():
	if !is_visible():
		set_visible(true)
	$Attack_sound.play()
	$sound_loop.start(2.43)


func _on_Timer_for_gael_timeout():
	get_tree().current_scene.get_node("gael").play()


func _on_stop_rage_mode_sound_timeout():
	$rage_mode_sound.stop()
