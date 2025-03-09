extends Area2D

func _on_body_entered(body: Node2D) -> void:
	var damage = 10
	SignalBus.player_damaged.emit(damage)
	print(body)
