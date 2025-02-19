extends RigidBody2D

const Laser_explosion_effect=preload("res://Laser_explosion.tscn")

func _ready():
	self.add_collision_exception_with(self)

func create_explosion():
	var main=get_tree().current_scene
	var laser_explosion_effect=Laser_explosion_effect.instance()
	main.add_child(laser_explosion_effect)
	laser_explosion_effect.global_position=global_position
