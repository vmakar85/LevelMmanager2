extends CharacterBody2D

var damage: int = 20
var bullet_vector : Vector2 = Vector2(0,-1)
var poused : bool = false
@export var speed : float = 200
@onready var area : Area2D = $EnemyBullet

func _ready() -> void:
	# Устанавливаем начальный масштаб
	scale.y = 0.1
	# Создаем Tween
	var tween = create_tween()
	# Настраиваем анимацию
	tween.tween_property(
		self,           # Объект для анимации
		"scale:y",      # Свойство для изменения (Y-компонент scale)
		1.0,            # Конечное значение
		1.0             # Длительность анимации в секундах
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	area.add_to_group("enemy_bullets")

func _physics_process(delta: float) -> void:
	global_position += bullet_vector.rotated(rotation) * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func qf() -> void: 
	queue_free()
