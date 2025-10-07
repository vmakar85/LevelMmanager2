extends Node

@onready var enemy_red_8: Sprite2D = $"../EnemyRed8"
@onready var enemy_red_type_8: CharacterBody2D = $".."
@export var is_need_trails : bool = false
 
func _process(_delta: float) -> void:
		if is_need_trails: 
			if (get_tree().get_frame() % 6 ) == 0: 
				var trail : Sprite2D = enemy_red_8.duplicate()
				trail.z_index = -1
				trail.global_position = enemy_red_type_8.global_position
				trail.rotation_degrees = enemy_red_8.rotation_degrees + 180
				trail.scale = enemy_red_type_8.scale
				trail.modulate.a = 0.7
				trail.add_to_group("trails")
				# Настраиваем твин для исчезновения
				var tween = trail.create_tween()
				tween.tween_property(trail, "modulate:a", 0.0, 0.7)  # Плавно убираем альфу
				tween.tween_callback(trail.queue_free)  # Удаляем после завершения
				get_tree().root.add_child(trail)
