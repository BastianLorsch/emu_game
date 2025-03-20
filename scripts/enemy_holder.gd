extends Node

var left_spawner_pos_x
var right_spawner_pos_x
var spawn_pos
@onready var spawn_timer = $Timer
 
func _ready() -> void:
	SignalBus.enemy_spawner_position.connect(_instance_enemy)
	spawn_timer.start()
	_on_timer_timeout()

func _instance_enemy(left, right):
	var i = randi_range(1, 2)
	if i == 1:
		spawn_pos = left
	else:
		spawn_pos = right
	var scene_enemy = load("res://scenes/enemy.tscn")
	var instance_enemy = scene_enemy.instantiate()
	add_child(instance_enemy)
	print("enemy instanced   ", i)
	
func _on_timer_timeout() -> void:
	SignalBus.get_enemy_spawner_position.emit()
