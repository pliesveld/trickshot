extends Label

func _ready():
	reset()

func reset():
	self.text = str(0)

func increment():
	self.text = str(int(self.text) + 1)
