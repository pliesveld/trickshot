extends Node2D


func _ready():
	var callback = func():
		print("Callback called!")
	
	$net.body_entered.connect(callback)
	$net.area_entered.connect(callback)
	
