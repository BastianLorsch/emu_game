extends CharacterBody2D
class_name player

const SPEED = 130
const JUMP_VELOCITY = -300

var current_state
var last_facing_direction = 1
var health = 100
var regenerating = false
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var healthbar = $Healthbar
@onready var weapon = $player_weapon
@onready var weapon_sprite = $player_weapon/Sprite2D
@onready var timer_regeneration = $Timer
@onready var enemy_spawner_left = $enemy_spawner_left
@onready var enemy_spawner_right = $enemy_spawner_right

func _ready() -> void:
	change_state("IdleState") # start in idle state
	animated_sprite.flip_h = true
	healthbar.init_health(health)
	SignalBus.player_damaged.connect(_set_health)
	SignalBus.start_game.connect(restore_health)
	SignalBus.get_enemy_spawner_position.connect(set_enemy_spawner_position)
	print(health)



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
	
	if regenerating == true:
		_set_health(-0.1)
	
func _set_health(damage):
	health = min(healthbar.max_value, health - damage)
	if health <= 0:
		SignalBus.player_dead.emit()
	healthbar.health = health
	if damage > 0:
		regenerating = false
		timer_regeneration.start()

func restore_health():
	health = 100
	healthbar.init_health(health)

func _on_timer_timeout() -> void:
	regenerating = true

func set_enemy_spawner_position():
	SignalBus.enemy_spawner_position.emit(enemy_spawner_left.global_position.x, enemy_spawner_right.global_position.x)
