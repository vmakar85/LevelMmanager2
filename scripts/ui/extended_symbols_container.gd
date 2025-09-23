extends HBoxContainer

var extended_symbols: Array[PowerupMappingResource] = []
 
func _ready() -> void:
	UiSignalBus.extended_symbol_add.connect(_on_extended_symbol_add)
	UiSignalBus.extended_symbol_erase.connect(_on_extended_symbol_erase)

# Создаем кнопки для всех базовых символов
func _setup() -> void:
	for child in get_children():
		child.queue_free()
	for key in extended_symbols:
		var res = Resources.enemy_ui_pic.get(key.enemy_id)["enemy"]
		var button = Button.new()
		button.custom_minimum_size = Vector2(40,40)
		button.icon = load(res.get("pic"))
		#button.tooltip_text = res.get("name") + " with powerup : " + extended_symbols.get(key)["powerup"]
		button.expand_icon = true
		button.text = key
		button.pressed.connect(_on_symbol_button_pressed.bind(key))
		add_child(button)

func _on_extended_symbol_add(symbol: Array[PowerupMappingResource]):
	extended_symbols = symbol
	_setup()

func _on_extended_symbol_erase(symbol: String):
	extended_symbols.erase(symbol)
	_setup()

func _on_symbol_button_pressed(symbol: String):
	UiSignalBus.emit_symbol_selected(symbol)
