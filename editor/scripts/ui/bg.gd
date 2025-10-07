extends Sprite2D

func _on_in_game_bg_on_off_toggled(toggled_on: bool) -> void:
	visible = toggled_on
	if toggled_on:
		RenderingServer.set_default_clear_color(Color.BLACK)
	else:
		RenderingServer.set_default_clear_color(Color.DIM_GRAY)
