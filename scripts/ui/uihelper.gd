extends Node

static func set_container_sizing(
	node: Control,
	h_flag: int = Control.SIZE_SHRINK_CENTER,
	v_flag: int = Control.SIZE_SHRINK_CENTER
) -> void:
	node.size_flags_horizontal = h_flag
	node.size_flags_vertical = v_flag


static func set_expand(node: Control, horizontal: bool = true, vertical: bool = false, ratio: float = 1.0) -> void:
	if horizontal:
		node.size_flags_horizontal = Control.SIZE_EXPAND
	if vertical:
		node.size_flags_vertical = Control.SIZE_EXPAND
	node.stretch_ratio = ratio
