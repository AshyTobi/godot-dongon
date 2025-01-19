extends Camera2D



func _on_area_2d_body_entered(body):
	print(DisplayServer.window_get_current_screen())

	#position = $"../Area2D".position
	get_window().content_scale_size = Vector2i(400,300)
