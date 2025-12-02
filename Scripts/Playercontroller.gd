extends CharacterBody2D

@export_range(0, 1000) var walk_speed = 300.0
var run_speed = walk_speed * 1.5
@export_range(0, 1) var deceleration = 0.1
@export_range(0, 1) var acceleration = 0.1

@export var jump_strength = -450.0
@export_range(0, 1) var decelerate_on_jump_release = 0.5
@export var wall_climb_speed = -250.0
var can_jump = true
var climbing = false
var can_climb = true

@export var dash_speed = 1000.0
@export var dash_max_distance = 150.0
@export var dash_curve : Curve
@export var dash_cooldown = 1.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var is_dashing = false
var dash_start_position = 0
var dash_direction = 0
var dash_timer = 0

func _ready():
	add_to_group("Player")

func _physics_process(delta):
	if not is_on_floor() and not climbing:
		velocity.y += gravity * delta
	elif not can_jump and is_on_floor():
		can_jump = true
	if not is_on_wall() and climbing:
		climbing = false
		
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if can_jump or is_on_wall():
			velocity.y = jump_strength
			can_jump = false
			
	if Input.is_action_just_released("jump"):
		if velocity.y < 0 and not climbing:
			velocity.y *= decelerate_on_jump_release
		
	if (is_on_floor() == false) and can_jump and $CoyoteTimer.is_stopped():
		$CoyoteTimer.start()
	
	var speed
	if Input.is_action_pressed("run"):
		speed = run_speed
	else:
		speed = walk_speed

	var direction = Input.get_axis("left", "right")

	if direction:
		velocity.x = move_toward(velocity.x, direction * speed, walk_speed * acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed * deceleration)

	# dash
	if Input.is_action_just_pressed("dash") and direction and not is_dashing and dash_timer <= 0:
		is_dashing = true
		dash_start_position = position.x
		dash_direction = direction
		
	if is_dashing:
		var current_distance = abs(position.x - dash_start_position)
		if current_distance >= dash_max_distance or is_on_wall():
			is_dashing = false
		else:
			velocity.x = dash_direction * dash_speed * dash_curve.sample(current_distance / dash_max_distance)
			velocity.y = 0
	
	if dash_timer > 0:
		dash_timer -= delta
		
	
	move_and_slide()


func _on_coyote_timer_timeout():
	can_jump = false
