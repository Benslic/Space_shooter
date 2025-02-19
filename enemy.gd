extends Area2D

const MINSPEED=30
const MAXSPEED=290

export(int) var armor =3
var speed:float

const ExplosionEffect=preload("res://ExplosionEffect.tscn")


#signal score_up

func _ready():
	randomize()
	speed=rand_range(MINSPEED,MAXSPEED)
	#var main=get_tree().current_scene
	#if main.is_in_group("World"):
		#connect("score_up",main,"_on_Enemy_score_up")

func _process(delta):
	position.x-=delta* speed



func _on_Area2D_body_entered(body):
	if body.is_in_group("Cool_group"):
		armor-=3
	elif body.is_in_group("deadly"):
		create_explosion()
		queue_free()
	else:
		body.create_hit_effect()
		body.queue_free()
		armor-=1
	#print("Armor after a damage: ",armor,'\n')
	if armor<=0:
		var main=get_tree().current_scene
		if main.is_in_group("World"):
			main.score+=10
		create_explosion()
		queue_free()

func create_explosion():
	var main=get_tree().current_scene
	var explosionEffect=ExplosionEffect.instance()
	main.add_child(explosionEffect)
	explosionEffect.global_position=global_position
	
