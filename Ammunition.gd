extends Node

var can_shoot_bullets=true
var can_shoot_sbullets=true


func update_ammunition_amount(var b=0, var sb=0):   #add b and sb to bullet and supperbullet respectively
	$Bullet_ammo.update_bullet_amount(b)
	$SuperBullet_ammo.update_Sbullet_amount(sb)
	
func new_hp_ammount(var n):
	$hp.update_info(n)
	
func _process(delta):
	if $Bullet_ammo.can_shoot():
		can_shoot_bullets=true
	else:
		can_shoot_bullets=false
	if $SuperBullet_ammo.can_shoot():
		#print("We are in Ammunition _process/if supperbullet.can_shoot()")
		can_shoot_sbullets=true
	else:
		#print("Can't shoot")
		can_shoot_sbullets=false
