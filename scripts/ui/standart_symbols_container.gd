extends HBoxContainer

var symbols = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "*"]

# Создаем кнопки для всех базовых символов
func _init() -> void:
	for symbol in symbols:
		var res = Resources.enemy_ui_pic.get(symbol)
		var button = Button.new()
		button.custom_minimum_size = Vector2(40,40)
		button.icon = load(res.get("pic"))
		button.tooltip_text = res.get("name")
		button.expand_icon = true
		button.text = symbol
		button.pressed.connect(_on_symbol_button_pressed.bind(symbol))
		add_child(button)

func _on_symbol_button_pressed(symbol: String):
	UiSignalBus.emit_symbol_selected(symbol)
