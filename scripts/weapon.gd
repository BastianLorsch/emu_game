extends Area2D

@onready var player_heart = get_node("../../../../Player/player_heart")
@onready var enemy = $".."
@onready var attack_cooldown = $Timer
@onready var attack_ani = $AnimatedSprite2D
@onready var weapon_collisionShape = $CollisionShape2D
var attacking = false
var attack_ready = true
func _process(delta: float) -> void:
	if !attacking:
		look_at(player_heart.global_position)
		weapon_collisionShape.disabled = true
	
	if !enemy.do_movement and attack_ready and !attacking:
		attacking = true
		weapon_collisionShape.disabled = false
	
	if attacking:
		attack_ready = false
		attack_cooldown.start()
		attack_ani.play()
		
	if attack_ani.is_playing():
		for i in attack_ani.frame:
			match i + 1:
				0: weapon_collisionShape.position.x = 14.466
				1: weapon_collisionShape.position.x = 61.771
				2: weapon_collisionShape.position.x = 134.784
				3: weapon_collisionShape.position.x = 61.771
				4: 
					weapon_collisionShape.position.x = 14.466
					attacking = false
					attack_ani.stop()

func _on_body_entered(body: Node2D) -> void:
	var damage = 10
	SignalBus.player_damaged.emit(damage)
	#print("weapon_damage", body)

func _on_timer_timeout() -> void:
	attack_ready = true
	
