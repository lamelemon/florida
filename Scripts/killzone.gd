extends Area2D

func _on_body_entered(_body):
	Global.inBody = true
	Global.takeDamage(20, 1)

func _on_body_exited(_body):
	Global.inBody = false
