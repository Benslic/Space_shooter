extends Area2D


var speed:float

const ExplosionEffect=preload("res://ExplosionEffect.tscn")

var hp=3
#signal score_up

func _ready():
	speed=17
	#var main=get_tree().current_scene
	#if main.is_in_group("World"):
		#connect("score_up",main,"_on_Enemy_score_up")

func _process(delta):
	position.x-=delta* speed



func _on_Enemy_for_horde_body_entered(body):
	if body.is_in_group("Cool_group"):
		create_explosion()
		queue_free()
	elif body.is_in_group("deadly"):
		create_explosion()
		queue_free()
	else:
		body.create_hit_effect()
		body.queue_free()
		hp-=1
	if hp<=0:
		create_explosion()
		queue_free()

func create_explosion():
	var main=get_tree().current_scene
	var explosionEffect=ExplosionEffect.instance()
	main.add_child(explosionEffect)
	explosionEffect.global_position=global_position
	


func _on_Enemy_for_horde_area_entered(area):
	if area.is_in_group("player"):
		return
	create_explosion()
	queue_free()
