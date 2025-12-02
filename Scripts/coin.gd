extends Area2D

var collected = false

func _on_body_entered(body: Node2D) -> void:
	if not collected and body.is_in_group("Player"):
		Global.coins += 1
		collected = true
		hide()
		if Global.coins >= 7:
			Global.reloadGame(true)
