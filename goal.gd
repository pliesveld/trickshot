extends Node2D


func _ready():
	var callback = func(area):
		print("Callback called!", area)
	
	$net.body_entered.connect(callback)
	$net.area_entered.connect(callback)

func _on_net_area_entered(area):
	printt("Goal!", area)
