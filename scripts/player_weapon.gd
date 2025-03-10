extends Area2D

var attacking = false
var attack_ready = true
@onready var attack_cooldown = $attack_cooldown

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if rotation_degrees > 360 or rotation_degrees < -360:
		rotation_degrees = 0
	
	if Input.is_action_just_pressed("attack") and !attacking and attack_ready:
		attacking = true
	
	if !attacking:
		look_at(get_global_mouse_position())
	elif attacking and attack_ready:
		attack_ready = false
		if rotation_degrees > 270 or rotation_degrees > -90 and rotation_degrees < 90 or rotation_degrees < -270:
			rotation_degrees += 60
		elif rotation_degrees < 270 or rotation_degrees < -90 and rotation_degrees > 90 or rotation_degrees > -270:
			rotation_degrees -= 60
		attack_cooldown.start()
		attacking = false


func _on_attack_cooldown_timeout() -> void:
	attack_ready = true
	print("attack ready")
