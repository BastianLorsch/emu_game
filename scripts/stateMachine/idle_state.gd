# idle state
extends PlayerState

@onready var player_weapon = $"../player_weapon"

func enter_state(player_node):
	super(player_node) # calls the same methode in parent class 
	player.velocity.x = 0
	$"../AnimatedSprite2D".play("idle")
	$"../CollisionShape2D".shape = preload("res://resources/player_standing_collisionshape.tres")
	$"../CollisionShape2D".position.y = -8

func handle_input(_delta):
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.change_state("JumpState")
	
	elif Input.get_axis("move_left", "move_right") != 0:
		player.change_state("RunState")
	
	elif Input.is_action_just_pressed("roll"):
		player.change_state("RollState")
	
	elif Input.is_action_pressed("crouch") and  player.is_on_floor():
		player.change_state("CrouchState")
		
	elif Input.is_action_just_pressed("attack") and !player_weapon.attacking and player_weapon.attack_ready:
		player_weapon.attacking = true
