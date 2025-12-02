extends Node

const playerMaxHealth = 100
var playerHealth = playerMaxHealth

var inBody = false
var canDamage = true

var coins = 0

signal reload
signal won

func reloadGame(Win):
	call_deferred("_deferred_reload", Win)

func _deferred_reload(Win):
	get_tree().reload_current_scene()
	Engine.time_scale = 1.0
	playerHealth = playerMaxHealth
	coins = 0
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	reload.emit()
	if Win:
		won.emit()

func takeDamage(dmg, cooldown):
	if inBody and canDamage:
		playerHealth -= dmg
		print("took damage ", playerHealth)
		if playerHealth <= 0:
			reloadGame(false)
		else:
			canDamage = false
			await get_tree().create_timer(cooldown).timeout
			canDamage = true
			takeDamage(dmg, cooldown)

func _process(_delta):
	if Input.is_action_just_pressed("reload"):
		reloadGame(false)

func startGame():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
