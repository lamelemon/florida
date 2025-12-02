extends CharacterBody2D  # Vaihda KinematicBody2D:ksi jos käytät Godot 3.x

@export_range(0,10000) var speed = 200.0  # Vihollisen liikkumisnopeus
@export_range(0,1) var acceleration = 0.1
@export_range(-100000,100000) var upperBoundary
@export_range(-100000,100000) var lowerBoundary
var player: CharacterBody2D = null  # Viittaus pelaajaan

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	# Hae pelaaja "Player"-ryhmästä
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0]  # Oletetaan, että ryhmässä on yksi pelaaja
	else:
		print("Pelaajaa ei löytynyt ryhmästä 'Player'")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	if player and lowerBoundary < player.position.x and player.position.x < upperBoundary:
		if player.position.x < position.x:
			velocity.x = move_toward(velocity.x, -speed, speed * acceleration)
		elif player.position.x > position.x:
			velocity.x = move_toward(velocity.x, speed, speed * acceleration)
		else:
			velocity.x = 0
	else:
		velocity.x = 0
			
#		var direction = (player.position.x < position.x and lowerBoundary < player.position.x and player.position.x < upperBoundary)
#		if direction:
#			velocity.x = move_toward(velocity.x, direction * speed, walk_speed * acceleration)
#		else:
#			velocity.x = move_toward(velocity.x, 0, walk_speed * deceleration)
	move_and_slide()
