extends CharacterBody2D
class_name player

const SPEED = 130
const JUMP_VELOCITY = -300

var current_state
var last_facing_direction = 1
var health = 100 : set = _set_health
var is_attacking = false
var attack_finished = false
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var healthbar = $Healthbar
@onready var weapon = $player_weapon


func _ready() -> void:
	change_state("IdleState") # start in idle state
	animated_sprite.flip_h = true
	healthbar.init_health(health)
	SignalBus.player_damaged.connect(_set_health)

func change_state(new_state_name: String):
	if current_state:
		current_state.exit_state() # exit current state, can be used because CharacterBody2D inherits node
	current_state = get_node(new_state_name)
	if current_state: # ensure new state exit  
		current_state.enter_state(self) # enter new state


func _physics_process(delta: float) -> void:
	# update direction based on input
	var direction = Input.get_axis("move_left", "move_right")
	# update last facing direction
	if direction:
		last_facing_direction = sign(direction)
		weapon.position.x *= last_facing_direction*(-1)
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# ensure a state is active
	if current_state:
		current_state.handle_input(delta) # delegate input handling to current state
	
	if Input.is_action_just_pressed("attack") and !attack_finished:
		is_attacking = true
		
	if is_attacking and weapon.rotation_degrees > -30 and !attack_finished:
		weapon.rotation_degrees -= 200 * delta
	elif is_attacking and !attack_finished:
		attack_finished = true
	elif attack_finished and weapon.rotation_degrees < 70:
		weapon.rotation_degrees += 100 * delta
	else: 
		attack_finished = false
		is_attacking = false
	
	move_and_slide()
	
	# Flip sprite
	if direction > 0:
		animated_sprite.flip_h = true
	elif direction < 0:
		animated_sprite.flip_h = false
	
func _set_health(new_health):
	health = min(healthbar.max_value, health - new_health)
	healthbar.health = health
	print(health, "player")
	
