extends CharacterBody2D

const SPEED = 50.0
const JUMP_VELOCITY = -400.0
@onready var player = get_node("../../Player")
@onready var weapon = $weapon
var is_attacking = false
var attack_finished = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var do_movement = true
	if player.position.x +30 > position.x and position.x > player.position.x -30:
		do_movement = false
	
	if do_movement:
		position.x = move_toward(position.x, player.position.x, delta * SPEED)
	else: is_attacking = true
	move_and_slide()
	
	#attack handling
	if is_attacking and weapon.rotation_degrees > -30 and !attack_finished:
		weapon.rotation_degrees -= 200 * delta
	elif is_attacking and !attack_finished:
		attack_finished = true
	elif attack_finished and weapon.rotation_degrees < 70:
		weapon.rotation_degrees += 100 * delta
	else: 
		attack_finished = false
		is_attacking = false
	
