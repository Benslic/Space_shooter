extends Node

const AsteroidsSpawner=preload("res://AsteroidsSpawner.tscn")



func add_asteroids_spawner():
	var main=get_tree().current_scene
	var asteroidsSpawner=AsteroidsSpawner.instance()
	main.add_child(asteroidsSpawner)



func _on_World_asteroids():
	add_asteroids_spawner()
