extends PlayerState

const DASH_SPEED = 200.0
const DASH_DURATION = 0.5
var dash_timer = 0.0

func enter_state(player_node):
	super(player_node)
	
	var direction = Input.get_axis("move_left", "move_right")
	if direction == 0:
		direction = player.last_facing_direction
	
	player.velocity.x = direction * DASH_SPEED
	dash_timer = DASH_DURATION
	$"../AnimatedSprite2D".play("roll")
	$"../CollisionShape2D".shape = preload("res://resources/player_crouching_collisionshape.tres")  #I-Frame hinzufügen!
	$"../CollisionShape2D".position.y = -6
	$"..".collision_layer = 2

func exit_state():
	$"..".collision_layer = 1

func handle_input(delta):
	dash_timer -= delta
	if dash_timer <= 0:
		if headroom_free():
			if Input.get_axis("move_left", "move_right") != 0:
				player.change_state("RunState")
			else:
				player.change_state("IdleState")
		else:
			player.change_state("CrouchState")
	if Input.is_action_just_pressed("jump"):
		player.change_state("JumpState")

func headroom_free() -> bool:
	var result = !$"../CrouchRayCast_1".is_colliding() && !$"../CrouchRayCast_2".is_colliding()
	return result
