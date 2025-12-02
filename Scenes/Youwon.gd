extends Label

func _ready():
	hide()
	Global.won.connect(winning)
	
func winning():
	show()
	await get_tree().create_timer(4).timeout
	hide()
