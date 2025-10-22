extends CharacterBody2D
class_name Enemy

var is_can_shoot = true
var anchor:Node2D
var is_idle = true
var is_dead = false

@export_group("enemies_setting")
@export var health: int = 10
@export var points: int = 10
@export var self_name: String = ""
@export var power_up: String 
#@onready var rays: Node2D = $Rays

# Добавляем свойство для отслеживания скорости
var current_speed: float = 0.0
var last_position: Vector2
var last_update_time: float = 0.0

func _ready() -> void:
	last_position = global_position
	last_update_time = Time.get_ticks_msec() 
	add_to_group("enemies")

func is_idle_invert() -> void:
	is_idle = !is_idle

func _process(_delta: float) -> void:
	if Globals.is_editor:
		global_position = anchor.global_position
	# Обновляем скорость перед любыми движениями
	else:
		update_speed()
		if health <= 0:
			explode(true)

func _on_safe_area_body_entered(_body: Node2D) -> void:
	is_can_shoot = false

func _on_safe_area_body_exited(_body: Node2D) -> void:
	is_can_shoot = true

func explode(_is_score_up: bool) -> void:
	if !is_dead:
		is_dead = true
		call_deferred("queue_free")

func take_damage(amount):
	health -= amount

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_bullets"):
		take_damage(area.damage)
		area.queue_free()

func self_destruction() -> void:
	health = 0

# Трейл будет использовать эту скорость
func get_instant_speed() -> float:
	return current_speed

func update_speed():
	var current_time = Time.get_ticks_msec()
	var time_delta = (current_time - last_update_time) / 1000.0  # в секундах
	if time_delta > 0:
		var distance = last_position.distance_to(global_position)
		current_speed = distance / time_delta
	else:
		current_speed = 0.0 
	last_position = global_position
	last_update_time = current_time

#func _physics_process(_delta: float) -> void:
	#if rays.ray_left.is_colliding() or rays.ray_right.is_colliding():
		#var r_collider: Node2D = rays.ray_right.get_collider()
		#var l_collider: Node2D = rays.ray_left.get_collider()
		#if r_collider or l_collider:
			#SignalBus.emit_switch_direction_request()
	
	
