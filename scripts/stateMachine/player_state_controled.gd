extends CharacterBody2D

const SPEED = 130
const JUMP_VELOCITY = -300

var current_state
var last_facing_direction = 1
var health = 100 : set = _set_health
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var healthbar = $Healthbar


func _ready() -> void:
	change_state("IdleState") # start in idle state
	animated_sprite.flip_h = true
	healthbar.init_health(health)

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
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# ensure a state is active
	if current_state:
		current_state.handle_input(delta) # delegate input handling to current state
	move_and_slide()
	
	# Flip sprite
	if direction > 0:
		animated_sprite.flip_h = true
	elif direction < 0:
		animated_sprite.flip_h = false
	
	
func _set_health(new_health):
	health = min(healthbar.max_value, new_health)
	healthbar.health = health
	print(health, "player")
