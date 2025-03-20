extends Node

signal player_damaged(damage) #emit in weapon (enemy)
signal player_dead() #emit in player
signal enemy_damaged(damage) #emit in player_weapon
signal start_game() #emit in button (title_screen)

signal enemy_spawner_position(left, right) #emit in player
signal get_enemy_spawner_position() #emit in enemy_holder (level_1)
