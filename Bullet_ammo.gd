extends Node

export var bullets=20
var maxbullets=100
var reloading_time=3

func _ready():
	$Counter.text=str(bullets)
	update_bullet_reloading()
	
func update_bullet_reloading():
	if bullets<maxbullets:
		$Tween.interpolate_property($bullet_rect,"color",Color.black,Color.white,reloading_time,Tween.TRANS_CIRC)
		$Tween.interpolate_property($bullet_rect2,"color",Color.black,Color.white,reloading_time,Tween.TRANS_CIRC)
		$Tween.interpolate_property($bullet_rect3,"color",Color.black,Color.white,reloading_time,Tween.TRANS_CIRC)
		$Tween.start()
		yield(get_tree().create_timer(reloading_time-0.3),"timeout")
		update_bullet_amount(3)
		yield(get_tree().create_timer(0.3),"timeout")
		update_bullet_reloading()
#
func update_bullet_amount(var n=0):
	if bullets+n>maxbullets:
		bullets+=maxbullets-bullets
	else:
		bullets+=n
	update_counter()
	if bullets-n==maxbullets:
		update_bullet_reloading()

func update_counter():
	$Counter.text=str(bullets)

func can_shoot():
	if (bullets==0):
		return false
	else:
		return true
