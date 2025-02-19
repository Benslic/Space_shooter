extends Area2D

var player_hp=15

var gravity_on=false
var inverted_on=false

export(int) var speed=85
export(int) var y_speed=100

var supper_timer=2

const Bullet = preload("res://Bullet.tscn")
const ExplosionEffect=preload("res://ExplosionEffect.tscn")
const SuperBullet=preload("res://SuperBullet.tscn")
const Ammunition=preload("res://Ammunition.tscn") 

var ammunition=Ammunition.instance()

var shoot_is_still_pressed=false
var Sbullet_with_sound=false

var get_ready_label_is_shown=false

signal player_death

func _ready():
	print("we are in ready")
	var main=get_tree().current_scene
	#main.add_child(ammunition)
	main.call_deferred("add_child",ammunition)
	ammunition.update_ammunition_amount(10,2)
	
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("ui_up"):
		if(inverted_on):
			velocity.y+=1
		else:
			velocity.y-=1
	if Input.is_action_pressed("ui_down"):
		if(inverted_on):
			velocity.y-=1
		else:
			velocity.y+=1
	if Input.is_action_pressed("ui_right"):
		if inverted_on:
			velocity.x-=1
		else:
			velocity.x+=1
	if Input.is_action_pressed("ui_left"):
		if inverted_on:
			velocity.x+=1
		else:
			velocity.x-=1
	if Input.is_action_just_pressed("ui_accept"):
		$SupperB_timer.start(supper_timer)
		$Hold_on.start(0.24)
		shoot_is_still_pressed=true
	if Input.is_action_just_released("ui_accept"):
		shoot_is_still_pressed=false
		if not $SupperB_timer.is_stopped():
			$SupperB_timer.stop()
			$build_up.stop()
			if ammunition.can_shoot_bullets:
				fire_bullet()
			else:
				$NoBullets_sound.play()
		else:
			if ammunition.can_shoot_sbullets:
				fire_supper_bullet()
			else:
				$NoSbullets_sound.play()	
				
	if velocity.length()>0 && velocity.x==0:
		velocity*=y_speed
	elif velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	if gravity_on:
		if position.y>=140:
			velocity.y-=0.5*speed
		elif position.y>=90:
			velocity.y-=0.4*speed
		else:
			velocity.y-=0.3*speed
	
	position +=velocity*delta
	position.x=clamp(position.x,8,312)
	position.y=clamp(position.y,8,172)

	
func fire_supper_bullet():
	ammunition.update_ammunition_amount(0,-1)
	var supper_bullet=SuperBullet.instance()
	var main=get_tree().current_scene
	main.add_child(supper_bullet)
	supper_bullet.global_position=global_position+Vector2(5,0)

func fire_bullet():
	ammunition.update_ammunition_amount(-1,0)
	var bullet=Bullet.instance()
	var main=get_tree().current_scene
	main.add_child(bullet)
	bullet.global_position = global_position
	


func _on_Player_area_entered(area):
	print("ENTERED! ")
	if area.is_in_group("boss_area"):
		queue_free()
		return
	elif area.is_in_group("deadly") && !area.is_in_group("lasers_group"):
		queue_free()
		return
	area.create_explosion()
	if (area.is_in_group("lasers_group")):
		area.hide()
	elif(area.is_in_group("special_laser")):
		area.hide_and_show()
	else:
		area.queue_free()
	player_hp-=1
	ammunition.new_hp_ammount(player_hp)
	
	if player_hp<=0:
		queue_free()

	
func _exit_tree():
	var main =get_tree().current_scene 
	var explosionEffect=ExplosionEffect.instance()
	main.add_child(explosionEffect)
	explosionEffect.global_position=global_position
	emit_signal("player_death")



func _on_Hold_on_timeout():
	if shoot_is_still_pressed:
		$build_up.play()




func _on_Get_ready_timeout():
	set_process(true)


func _on_Player_body_entered(body):
	if body.is_in_group("deadly") && body.is_in_group("lasers_group"):
		player_hp-=1
		body.create_explosion()
		body.queue_free()
	elif body.is_in_group("deadly"):
		queue_free()
	ammunition.new_hp_ammount(player_hp)	
		
	if player_hp<=0:
		queue_free()

func disable_all_collision():
	$CollisionPolygon2D.set_deferred("disabled", true)
