extends Area2D

var attacking = false
var attack_ready = true
@onready var attack_cooldown = $attack_cooldown
@onready var collision_shape = $CollisionPolygon2D
@onready var attack_ani = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("attack") and !attacking and attack_ready:
		attacking = true
	
	if !attacking:
		look_at(get_global_mouse_position())
		collision_shape.disabled = true
		
	elif attacking and attack_ready:
		attack_ready = false
		attack_cooldown.start()
		collision_shape.disabled = false
		attack_ani.play()
		print(collision_shape.disabled)
	
	if attack_ani.frame == 4:
		attack_ani.stop()
		attacking = false

func _on_attack_cooldown_timeout() -> void:
	attack_ready = true
	print("attack ready")
