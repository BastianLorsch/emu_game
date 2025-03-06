extends Area2D

func _on_body_entered(body: Node2D) -> void:
	var damage = 10
	SignalBus.damaged.emit(damage)
	print("damage")
