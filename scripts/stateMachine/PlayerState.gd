# base class for all player states
# nessessary functions for this class are defined here 
extends Node
class_name PlayerState
# Reference to player node controled by this state 
var player

# called when entering this state 
func enter_state(player_node):
	player = player_node

# called when exiting this state
func exit_state():
	pass

func handle_input(_delta):
	pass # no input handling in the base state,
	# each specific state has its own input handling
