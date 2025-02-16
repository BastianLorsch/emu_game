extends Button

signal start_game()
# Called when the node enters the scene tree for the first time.
func _pressed():
	start_game.emit()
