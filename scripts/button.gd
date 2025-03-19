extends Button

# Called when the node enters the scene tree for the first time.
func _pressed():
	SignalBus.start_game.emit()
	print("start game")
