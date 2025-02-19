extends Area2D


const Laser_explosion_effect=preload("res://Laser_explosion.tscn")

func _ready():
	pass

func create_explosion():
	var main=get_tree().current_scene
	var laser_explosion_effect=Laser_explosion_effect.instance()
	main.add_child(laser_explosion_effect)
	laser_explosion_effect.global_position=global_position

func hide_and_show():
	$Sprite.set_visible(false)
	$Collision.set_disabled(true)
	$Timer.start(2)





func _on_Timer_timeout():
	$Sprite.set_visible(true)
	$Collision.set_disabled(false)


func _on_Special_Laser_Beam_body_entered(body):
	if body.is_in_group("Cool_group") || body.is_in_group("player_bullets"):
		body.create_hit_effect()
		body.queue_free()
