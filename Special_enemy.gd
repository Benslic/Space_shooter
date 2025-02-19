extends Area2D

const MINSPEED=100
const MAXSPEED=200

export(int) var armor =3
var speed:float

const ExplosionEffect=preload("res://ExplosionEffect.tscn")


#signal score_up

func _ready():
	randomize()
	
	speed=rand_range(MINSPEED,MAXSPEED)
	


func _process(delta):
	position.x-=delta* speed

	

func create_explosion():
	var main=get_tree().current_scene
	var explosionEffect=ExplosionEffect.instance()
	main.add_child(explosionEffect)
	explosionEffect.global_position=global_position
	


func _on_Special_enemy_body_entered(body):
	if body.is_in_group("Cool_group"):
		create_explosion()
		body.queue_free()
		queue_free()
	elif body.is_in_group("deadly"):
		create_explosion()
		queue_free()
	else:
		body.queue_free()
	


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


