extends Node2D

@onready var button = $title_screen/Button

func on_scene_instance():
	SignalBus.start_game.connect(_instance_game_start)
	SignalBus.player_dead.connect(_on_player_dead)

func _ready() -> void:
	on_scene_instance()

func _instance_game_start():
	var scene_player = load("res://scenes/player.tscn")
	var scene_level_1 = load("res://scenes/level_1.tscn")
	var instance_player = scene_player.instantiate()
	var instance_level_1 = scene_level_1.instantiate()
	add_child(instance_player)
	add_child(instance_level_1)
	remove_child($title_screen)
	print("instanced")
	
func _on_player_dead():
	remove_child($Player)
	remove_child($level_1)
	var scene_title_screen = load("res://scenes/title_screen.tscn")
	var instance_title_screen = scene_title_screen.instantiate()
	add_child(instance_title_screen)
	
