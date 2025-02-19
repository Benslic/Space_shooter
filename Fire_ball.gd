extends RigidBody2D

const Fireball_explosion_effect=preload("res://Fireball_explosion.tscn")

func _ready():
	pass

func create_explosion():
	var main=get_tree().current_scene
	var fireball_explosion_effect=Fireball_explosion_effect.instance()
	main.add_child(fireball_explosion_effect)
	fireball_explosion_effect.global_position=global_position
