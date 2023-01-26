extends Node2D


func _ready():
	self.add_to_group("entities")
	var callback = func(area):
		var tween = self.get_tree().create_tween()
		tween.tween_callback(func(): $%Timer.stop())
		tween.tween_callback(func(): $%Audio.play())
		tween.tween_callback(func(): $%score_left.increment()).set_delay(0.5)
		tween.tween_callback(func(): $/root/Trickshot.reset()).set_delay(2.2)
		tween.tween_callback(func(): $%Timer.start())
		
	
#	$net.body_entered.connect(callback)
	$net.area_entered.connect(callback)
	self.set_physics_process(true)

func reset():
	self.set_physics_process(false)

func _on_net_area_entered(area):
	printt("Goal!", area)
