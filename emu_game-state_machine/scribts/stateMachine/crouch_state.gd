extends PlayerState


func enter_state(player_node):
	super(player_node) # calls the same methode in parent class 
	$"../AnimatedSprite2D".play("crouch")
	$"../CollisionShape2D".shape = preload("res://resources/player_crouching_collisionshape.tres")
	$"../CollisionShape2D".position.y = -6
	var stuck_under_object = false


func handle_input(_delta):
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		player.velocity.x = direction * player.SPEED
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
	
	if direction:
		if Input.is_action_just_released("crouch") and headroom_free():
			player.change_state("RunState")
		
		elif !Input.is_action_pressed("crouch") and headroom_free():
			player.change_state("RunState")
	else:
		if Input.is_action_just_released("crouch") and headroom_free():
			player.change_state("IdleState")
		
		elif !Input.is_action_pressed("crouch") and headroom_free():
			player.change_state("IdleState")
	
	if Input.is_action_just_pressed("jump") and  player.is_on_floor() and headroom_free():
		player.change_state("JumpState")
	
	elif Input.is_action_just_pressed("roll") and  player.is_on_floor():
		player.change_state("RollState")



func headroom_free() -> bool:
	var result = !$"../CrouchRayCast_1".is_colliding() && !$"../CrouchRayCast_2".is_colliding()
	return result
