extends Area2D

var supper_explosion_counter=4

const Ufo_laser=preload("res://Ufo_laser.tscn")
const Special_enemy=preload("res://Special_enemy.tscn")
const Special_enemy_entry=preload("res://Special_enemy_entry.tscn")
const Fire_ball=preload("res://Fire_ball.tscn")
const Super_explosion=preload("res://Super_explosion.tscn")
const Stage_1_1=preload("res://Stage_1-1.tscn")
const Asteroids_Spawner=preload("res://AsteroidsSpawner.tscn")
const Boss_life_bar=preload("res://Boss_life_bar.tscn")

var life_bar_instance=Boss_life_bar.instance()
var life_bar=life_bar_instance.get_node("life")
var life_bar_is_shown=false

var hp=300
var max_hp=300

var from_top="top"
var from_bottom="bottom"
var current_fire_attack=from_bottom

var v_bottom=Vector2(0,170)
var v_top=Vector2(0,9)
var v_center=Vector2(0,90)


var speed1=0.5
var speed2=1.8
var current_speed=speed1

var prepare_fire_attack=false
var start_fire_attack=false
var right_spot_to_fire=false
#var stop_every_attack=false

var rage_mode_on=false
var semi_rage_on=false


var attack_amount:int

func _ready():
	randomize()
	
	$Collision.set_deferred("disabled", true)
	$Shield/Shield.set_deferred("disabled", true)
	
#	get_node("Collision").disabled=true
#	get_node("Shield/Shield").disabled=true
	$Next_decision.start(3)
	#get_tree().set_debug_collisions_hint(true) 


func _on_Next_decision_timeout():
	if get_parent().stop_every_attack:
		return
	print("In next decision")
	if !life_bar_is_shown:
		life_bar_is_shown=true
		get_parent().add_child(life_bar_instance)
	decide_attack()
	

func decide_attack():
	if get_parent().stop_every_attack:
		return
	
	var attack_n=randi()%5+1
	
	if attack_n==1|| attack_n==3|| attack_n==2:
		attack_amount=randi()%7+2
		print("attack amount: ",attack_amount)
		spawn_special_enemy()
	else :
		var choose=randi()%2
		if choose == 0:
			current_fire_attack=from_bottom
		else:
			current_fire_attack=from_top
		prepare_fire_attack=true
		$Check_Fire/Particles2D.set_emitting(true)
	
func _process(delta):
	if prepare_fire_attack:
		var velocity=Vector2.ZERO
		if current_fire_attack==from_bottom:
			velocity.y=(v_bottom.y-global_position.y)*2
		else:
			velocity.y=(v_top.y-global_position.y)*2
			
		global_position+=velocity*delta
		if global_position.y<10 || global_position.y>169:
			prepare_fire_attack=false
			$Check_Fire/Particles2D.set_emitting(false)
			start_fire_attack=true
			right_spot_to_fire=true
	elif start_fire_attack:

		if right_spot_to_fire:
			right_spot_to_fire=false
			emit_fire_attack()
			$wait_for_right_spot.start(0.7)
		var velocity=Vector2.ZERO
		velocity.y=(v_center.y-position.y)*0.6
		position+=velocity*delta
		
		if position.y>85 && position.y<95:
			start_fire_attack=false
			$Next_decision.start(rand_range(1,2.7))
			
	else:	
		if get_parent().player_is_dead:
			set_process(false)
		var ship_coord=position
		if get_tree().current_scene.get_node("Player"):
			ship_coord=get_tree().current_scene.get_node("Player").position
		#print("player's coordinate : ",ship_coord)
		var velocity = Vector2.ZERO # The player's movement vector.

		velocity.y=(ship_coord.y-global_position.y)*current_speed
		global_position +=velocity*delta

func _on_Stage_1_body_entered(body):
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
	
	if hp<=max_hp*0.75 && !semi_rage_on:
		semi_rage_on=true
		make_harder()
	
	if hp<=max_hp/2 && !rage_mode_on:
		rage_mode()
	
	if hp<=0&& !get_parent().first_boss_is_dead:	#additional checking so that another collision polygon won't detect body and call death()
		get_parent().first_boss_is_dead=true
		create_super_explosion()
		death()
	
	
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
	
	if hp<=max_hp*0.75 && !semi_rage_on:
		semi_rage_on=true
		make_harder()
	
	if hp<=max_hp/2 && !rage_mode_on:
		rage_mode()
		
	if hp<=0 && !get_parent().first_boss_is_dead:
		get_parent().first_boss_is_dead=true
		create_super_explosion()
		death()

func create_super_explosion():
	
	var main=get_tree().current_scene
	var super_explosion=Super_explosion.instance()
	main.add_child(super_explosion)
	super_explosion.global_position=position
	$continuous_explosion.start(2)

func death():
	$Collision.set_deferred("disabled", true)
	$Shield/Shield.set_deferred("disabled", true)
	if !get_parent().player_is_dead:
		get_parent().get_node("Player").disable_all_collision()		# I know it's ugly but it's too late...
	get_parent().get_node("Enemies_Horde").queue_free()
	get_parent().get_node("Laser_spawner").queue_free()
	
	if !get_parent().second_boss_is_dead:
		get_parent().get_node("Stage_1-1").create_super_explosion()
		get_parent().get_node("Stage_1-1").queue_free()
	
	get_node("2Stage").set_visible(false)
	get_parent().get_node("Player").gravity_on=false
	get_parent().get_node("Blue_light").set_emitting(false)	
	get_tree().current_scene.get_node("gael_loop").stop()
	get_tree().current_scene.get_node("gael").stop()
	
	get_parent().boss_fight=true
	get_parent().stop_every_attack=true
	
	
	set_process(false)
	get_parent().the_end()
	yield(get_tree().create_timer(10),"timeout")
	
	queue_free()

func counter_attack(var body):
	var main=get_tree().current_scene
	var ufo_laser=Ufo_laser.instance()
	ufo_laser.global_position=body.global_position
	body.queue_free()
	main.add_child(ufo_laser)
	

func spawn_special_enemy():
	if get_parent().stop_every_attack:
		return
	#print("loon pos:",position)
	#print("spawner pos: ",$spawner.position)
	var main=get_tree().current_scene
	
	var Senemy_entry=Special_enemy_entry.instance()
	add_child(Senemy_entry)
	Senemy_entry.global_position=position
	print("enemy.position: ",Senemy_entry.position)
	$enemy_spew_timer.start(rand_range(1,3))
	attack_amount-=1

func emit_fire_attack():
	
	var main=get_tree().current_scene
	var fire_ball=Fire_ball.instance()
	main.add_child(fire_ball)
	fire_ball.global_position=position


func _on_enemy_spew_timer_timeout():
	if get_parent().stop_every_attack:
		return
	if attack_amount:
		$enemy_spew_timer.start(rand_range(1,1.5))
		spawn_special_enemy()
	else:
		$Next_decision.start(rand_range(2,3))




func _on_wait_for_right_spot_timeout():
	right_spot_to_fire=true


func make_harder():
#	get_node("Collision").disabled=true
#	get_node("Shield/Shield").disabled=true
	$Collision.set_deferred("disabled", true)
	$Shield/Shield.set_deferred("disabled", true)
	set_process(false)
	get_parent().get_node("Blue_light").set_amount(200)
	get_parent().get_node("Laser_spawner").current_difficulty="hard"
	current_speed=speed2
	get_parent().get_node("Player").gravity_on=true
	$rage_mode_sound.play()
	$stop_rage_mode_sound.start(3.7)
	

func rage_mode():
	rage_mode_on=true
#	get_node("Collision").disabled=true
#	get_node("Shield/Shield").disabled=true

	$Collision.set_deferred("disabled", true)
	$Shield/Shield.set_deferred("disabled", true)
	current_fire_attack=0
	set_process(false)
	$Next_decision.stop()
	get_parent().get_node("boss_music").stop()
	$rage_mode_sound.play()
	$stop_rage_mode_sound.start(6.18)
	var main=get_tree().current_scene
	var stage_1_1=Stage_1_1.instance()
	main.add_child(stage_1_1)
	$prepare_for_rage_mode.start(5)
	



func _on_prepare_for_rage_mode_timeout():
	$Timer_for_ultra_rage.start(125)
	get_parent().stop_every_attack=false
#	get_node("Collision").disabled=false
#	get_node("Shield/Shield").disabled=false

	$Collision.set_deferred("disabled", false)
	$Shield/Shield.set_deferred("disabled", false)
	
	get_parent().get_node("Laser_spawner").current_difficulty="special"
	get_parent().get_node("Laser_spawner").rapid_mode=true
	$Next_decision.start(1)
	set_process(true)
	


func _on_stop_rage_mode_sound_timeout():
	$rage_mode_sound.stop()
#	get_node("Collision").disabled=false
#	get_node("Shield/Shield").disabled=false

	$Collision.set_deferred("disabled", false)
	$Shield/Shield.set_deferred("disabled", false)
	
	set_process(true)


func _on_Timer_for_ultra_rage_timeout():
	get_parent().get_node("1StageBackground/Transition").play("ultra_rage")
	get_parent().ultra_rage_anim_is_played=true
	get_parent().add_child(Asteroids_Spawner.instance())
	$timer_before_gael2.start(80.4)


func _on_timer_before_gael2_timeout():
	get_tree().current_scene.get_node("gael").stop()
	get_tree().current_scene.get_node("gael_loop").play()
	$timer_gael2.start((54.43))


func _on_timer_gael2_timeout():
	get_tree().current_scene.get_node("gael_loop").stop()
	get_tree().current_scene.get_node("gael_loop").play()
	$timer_gael2.start((54.43))


func _on_entry_timer_timeout():
#	get_node("Collision").disabled=false
#	get_node("Shield/Shield").disabled=false
	$Collision.set_deferred("disabled", false)
	$Shield/Shield.set_deferred("disabled", false)
	


func _on_continuous_explosion_timeout():
	supper_explosion_counter-=1
	if supper_explosion_counter>0:
		create_super_explosion()
	
