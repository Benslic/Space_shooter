extends Area2D

const Stage_1=preload("res://Stage_1.tscn")


var hp=100
	
func _ready():
	$Animation.play("enter")
	$Collision.set_deferred("disabled", true)
	if !get_parent().player_is_dead:
		get_tree().current_scene.get_node("Player").inverted_on=true

var first_time=true
var idlefinished=false
var end_stage=false

func _on_Animation_animation_finished(anim_name):
	print("We are here second time")
	if anim_name=="enter":
		print("We are here")
		$Collision.set_deferred("disabled", false)
		$music.play()
		$idleAnimation.play("idle")
	if anim_name=="first_attack":
		$Animation.play("final")
	if anim_name=="final":
		$Animation.play("first_attack")

func _on_Stage_0_body_entered(body):
	if !end_stage:
		if body.is_in_group("Cool_group"):	
			hp-=15
		else:
			hp-=1
		body.create_hit_effect()
		
		body.queue_free()
		print("Armor after a damage: ",hp,'\n')
		if hp<=90 &&first_time && idlefinished:
			first_time=false
			$Animation.play("first_attack")
		if hp<=0:
			end_stage_0()

func end_stage_0():
	end_stage=true
	$Collision.set_deferred("disabled", true)
	$idleAnimation.stop()
	$Animation.stop()
	$music.stop()
	$end_stage_sound.play()
	particles_rage()
	yield(get_tree().create_timer(6.18),"timeout")
	$end_stage_sound.stop()
	yield(get_tree().create_timer(2),"timeout")
	get_tree().change_scene("res://Final_stage.tscn")


func particles_rage():
	$Stars_from_loon.amount=200
	$Stars_from_loon2.amount=200
	$Stars_from_loon4.amount=200
	$Stars_from_loon4.speed_scale=2
	$Stars_from_loon5.speed_scale=2
	$Stars_from_loon3.speed_scale=2

func _on_idleAnimation_animation_finished(anim_name):
	if hp>90:
		$idleAnimation.play("idle")
	else:
		idlefinished=true


