
extends CharacterBody2D


@export var STAND_SPEED = 130
@export var CROUCH_SPEED = 80
@export var JUMP_VELOCITY = -300.0
var speed = STAND_SPEED

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_rolling = false
var is_crouching = false
var stuck_under_object = false

var standing_collisionshape = preload("res://resources/player_standing_collisionshape.tres")
var crouching_collisionshape = preload("res://resources/player_crouching_collisionshape.tres")
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@onready var crouch_raycast1: RayCast2D = $CrouchRayCast_1
@onready var crouch_raycast2: RayCast2D = $CrouchRayCast_2


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("roll") and is_on_floor():
		roll()
	
	# Get the input direction: -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	
	# Flip sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true 
	
	# Play animations 
	if is_on_floor():
		if direction == 0:
			if is_crouching:
				animated_sprite.play("crouch")
			elif is_rolling:
				animated_sprite.play("roll")
			else:
				animated_sprite.play("idle")
		else:
			if is_crouching:
				animated_sprite.play("crouch_walk")
			else:
				animated_sprite.play("run")
	else:
		if is_crouching:
				animated_sprite.play("crouch")
		else:
			animated_sprite.play("jump")
	
	# Apply movement
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	# Apply state: stand, crouch 
	if Input.is_action_just_pressed("crouch"):
		crouch()
	elif Input.is_action_just_released("crouch"):
		if headroom_free():
			stand()
		else:
			if stuck_under_object != true:
				stuck_under_object = true
	
	# resets state to stand if hedroom is free again
	if stuck_under_object && headroom_free():
		if !Input.is_action_pressed("crouch"):
			stand()
		stuck_under_object = false
	
	move_and_slide()

# creating new functions here

func crouch() -> void:
	if is_crouching:
		return
	else:
		is_crouching = true
		collision_shape.shape = crouching_collisionshape
		collision_shape.position.y = -6
		speed = CROUCH_SPEED

func stand() -> void:
	if is_crouching == false:
		return
	else:
		is_crouching == false
		collision_shape.shape = standing_collisionshape
		collision_shape.position.y = -8
		speed = STAND_SPEED

func headroom_free() -> bool:
	var result = !crouch_raycast1.is_colliding() && !crouch_raycast2.is_colliding()
	return result

func roll():
	var is_rolling = true
