extends Area2D


func _process(delta: float) -> void:

	pass


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		print("Ken")
		get_tree().reload_current_scene()
	
	pass # Replace with function body.
