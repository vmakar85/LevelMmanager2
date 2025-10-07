extends Node

@export var debug: bool = true

signal switch_direction_request

func emit_switch_direction_request():
	if debug:
		print("switch_direction_request")
	switch_direction_request.emit()
