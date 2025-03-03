extends CharacterBody2D

const SPEED = 50.0
const JUMP_VELOCITY = -400.0
@onready var player = get_node("../../Player")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var puffer
	var do_movement = true
	if player.position.x +30 > position.x and position.x > player.position.x -30:
		do_movement = false
	elif player.position.x > position.x:
		puffer = -30
	else: puffer = 30
	
	if do_movement:
		position.x = move_toward(position.x, player.position.x + puffer, delta * SPEED)
	move_and_slide()
