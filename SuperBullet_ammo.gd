extends Node

export var Sbullets=2
var maxbullets=10
var reloading_time=9

func _ready():
	$Counter.text=str(Sbullets)
	update_Sbullet_reloading()
	
func update_Sbullet_reloading():
	if Sbullets<maxbullets:
		$Tween.interpolate_property($SBullet_rect,"color",Color.black,Color.white,reloading_time,Tween.TRANS_LINEAR)
		$Tween.start()
		yield(get_tree().create_timer(reloading_time-0.2),"timeout")
		update_Sbullet_amount(1)
		yield(get_tree().create_timer(0.2),"timeout")
		update_Sbullet_reloading()
		
func update_Sbullet_amount(var n=0):
	#print("trying to update sbullet with: ",n,"\n")
	Sbullets+=n
	update_counter()
	if Sbullets-n==maxbullets:		#only if last addition changed Sbullets from maxbullets value (substracted)
		update_Sbullet_reloading()

func update_counter():
	$Counter.text=str(Sbullets)

func can_shoot():
	if (Sbullets==0):
		return false
	else:
		return true
