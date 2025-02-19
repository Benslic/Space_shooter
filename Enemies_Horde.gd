extends Node2D
const White_enemy=preload("res://Enemy_for_horde.tscn")
const Red_enemy=preload("res://Special_enemy_for_horde.tscn")


func _ready():
	randomize()
	

func start():
	$warning.play()
	$turn_off_sound_timer.start(1.85)


func _on_Next_attack_timeout():
	$Next_attack.start(2)
	emit_attack()


func _on_turn_off_sound_timer_timeout():
	$warning.stop()
	emit_attack()
	$Next_attack.start(2)

func emit_attack():
	var points=$Spawn_Points.get_children()
	for p in points:
		if (randi()%6==5):
			var red=Red_enemy.instance()
			get_tree().current_scene.add_child(red)
			red.global_position=p.global_position
		else:
			var white=White_enemy.instance()
			get_tree().current_scene.add_child(white)
			white.global_position=p.global_position
