extends Area2D

func _on_hutbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		queue_free()

