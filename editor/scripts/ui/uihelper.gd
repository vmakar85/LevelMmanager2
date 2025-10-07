extends Node

static func set_container_sizing(
	node: Control,
	h_flag: int = Control.SIZE_SHRINK_CENTER,
	v_flag: int = Control.SIZE_SHRINK_CENTER
) -> void:
	node.size_flags_horizontal = h_flag
	node.size_flags_vertical = v_flag

func margin_theme_constant_override(node: Control,margin_value = 20 ) -> void:
	node.add_theme_constant_override("margin_top", margin_value)
	node.add_theme_constant_override("margin_left", margin_value)
	node.add_theme_constant_override("margin_bottom", margin_value)
	node.add_theme_constant_override("margin_right", margin_value)

static func set_expand(node: Control, horizontal: bool = true, vertical: bool = false, ratio: float = 1.0) -> void:
	if horizontal:
		node.size_flags_horizontal = Control.SIZE_EXPAND
	if vertical:
		node.size_flags_vertical = Control.SIZE_EXPAND
	node.stretch_ratio = ratio
