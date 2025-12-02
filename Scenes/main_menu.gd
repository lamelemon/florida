extends MarginContainer

func _ready():
	Global.reload.connect(showMenu)
	
func showMenu():
	$".".show()
