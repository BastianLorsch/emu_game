extends Area2D

@onready var player_heart = get_node("../../../Player/player_heart")
@onready var enemy = $".."
@onready var attack_cooldown = $Timer
var attacking = false
var attack_ready = true

func _process(delta: float) -> void:
	if !attacking:
		look_at(player_heart.global_position)
	
	if !enemy.do_movement and attack_ready and !attacking:
		attacking = true
	
	if attacking:
		attack_ready = false
		#var position_difference_x = player_heart.position.x - position.x
		#var position_difference_y = player_heart.position.y - position.y
		
		attack_cooldown.start()
		attacking = false
		position -= Vector2(100, 100)

func _on_body_entered(body: Node2D) -> void:
	var damage = 10
	SignalBus.player_damaged.emit(damage)
	print(body)

func _on_timer_timeout() -> void:
	attack_ready = true
	
