extends HBoxContainer

var extended_symbols: Array[EnemyOverrideResource]
 
func _ready() -> void:
	UiSignalBus.extended_symbol_add.connect(_on_extended_symbol_add)
	UiSignalBus.extended_symbol_erase.connect(_on_extended_symbol_erase)

# Создаем кнопки для всех базовых символов
func _setup() -> void:
	for child in get_children():
		child.queue_free()
	for key in extended_symbols:
		var res = Resources.enemy_ui_pic.get(key.get_enemy_id()) # <- тут достаем картинку для врага
		var button = Button.new()
		button.custom_minimum_size = Vector2(40,40)
		button.icon = load(res.get("pic"))
		button.tooltip_text = res.get("name") + " with powerup : " + key.get_powerup_name()
		button.expand_icon = true
		button.text = key.get_enemy_overrided_id()
		button.pressed.connect(_on_symbol_button_pressed.bind(key.get_enemy_overrided_id()))
		add_child(button)

func _on_extended_symbol_add(symbol: Array[EnemyOverrideResource]):
	extended_symbols = symbol
	_setup()

func _on_extended_symbol_erase(symbol: String):
	extended_symbols.erase(symbol)
	_setup()

func _on_symbol_button_pressed(symbol: String):
	UiSignalBus.emit_symbol_selected(symbol)
