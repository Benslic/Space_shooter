extends RigidBody2D

const SuperHitEffect=preload("res://SuperHitEffect.tscn")

var armor=3

func _ready():
	pass


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func create_hit_effect():
	var main=get_tree().current_scene
	var superHitEffect=SuperHitEffect.instance()
	main.add_child(superHitEffect)
	superHitEffect.global_position=global_position
	

