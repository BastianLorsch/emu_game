extends Node2D

func _ready() -> void:
	var button = $title_screen/Button
	button.start_game.connect(instance_game_start)

func instance_game_start():
	var scene_player = load("res://scenes/player.tscn")
	var scene_level_1 = load("res://scenes/level_1.tscn")
	var instance_player = scene_player.instantiate()
	var instance_level_1 = scene_level_1.instantiate()
	add_child(instance_player)
	add_child(instance_level_1)
	remove_child($title_screen)
	
#func remove_instance ():
	#remove_child()
