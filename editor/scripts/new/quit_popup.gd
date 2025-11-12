extends Popup


func _ready() -> void:
	pass


func _on_ok_pressed() -> void:
	get_tree().quit()


func _on_cancel_pressed() -> void:
	hide()
