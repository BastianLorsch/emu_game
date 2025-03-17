extends PlayerState

@onready var player_weapon = $"../player_weapon"

var call_to_roll : bool

func enter_state(player_node):
	super(player_node) # calls the same methode in parent class 
	player.velocity.y = player.JUMP_VELOCITY
	$"../AnimatedSprite2D".play("jump")
	call_to_roll = false

func handle_input(_delta):
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		player.velocity.x = direction * player.SPEED
		
	if player.is_on_floor() and call_to_roll == true and !Input.is_action_pressed("crouch"):
		player.change_state("RollState")
	elif player.is_on_floor():
		player.change_state("IdleState")
	# if player presses "roll" mid air it's remembert to execute as soon as he is on floor (makes movement a bit smoother)
	if Input.is_action_just_pressed("roll"):
		call_to_roll = true
	
	elif Input.is_action_just_pressed("attack") and !player_weapon.attacking and player_weapon.attack_ready:
		player_weapon.attacking = true
