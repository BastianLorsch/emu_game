extends CharacterBody2D
class_name enemy

const SPEED = 50.0
const JUMP_VELOCITY = -400.0
@onready var weapon = $weapon
@onready var healthbar = $Healthbar 
@onready var player = get_node("../../../Player")
@onready var spawner = $".."
var health = 150 : set = _set_health
var do_movement = true

func _ready() -> void:
	position.x = spawner.spawn_pos
	healthbar.init_health(health)
	SignalBus.enemy_damaged.connect(_set_health)
	SignalBus.player_dead.connect(_on_player_dead)
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var player_x_pos = player.position.x
	
	if player_x_pos +30 > position.x and position.x > player_x_pos -30:
		do_movement = false
	else:
		do_movement = true
	
	if do_movement:
		position.x = move_toward(position.x, player.position.x, delta * SPEED)
	move_and_slide()

func _set_health(damage):
	health = min(healthbar.max_value, health - damage)
	healthbar.health = health
	if  health <= 0:
		queue_free()

func _on_player_dead():
	queue_free()
