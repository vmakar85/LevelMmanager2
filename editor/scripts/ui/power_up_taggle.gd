extends Path2D

const CONTINUE = preload("uid://c4jb2ugfqktcf")
const HP = preload("uid://dtffa2a0lnbl5")
const SHIELD = preload("uid://bkpcpn8ah6nn4")
const SHOOT_POWER_UP = preload("uid://hrk8c7i3ipbf")
const SHOOT_SPEED_UP = preload("uid://b68fqki0ynkng")
const SPEEDUP = preload("uid://bbgsd6phhl6kc")

@onready var path_follow_2d: PathFollow2D = $PathFollow2D
var is_spawn_need
var is_waiting = false

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if is_spawn_need and not is_waiting:
		is_waiting = true
		await get_tree().create_timer(1.0).timeout
		_spawn_rain()
		is_waiting = false

func _on_button_toggled(toggled_on: bool) -> void:
	is_spawn_need = toggled_on

func _spawn_rain() -> void:
	path_follow_2d.progress_ratio = randf()
	var random_number = randi() % 6 
	var pop
	match random_number:
		0:
			pop = CONTINUE.instantiate()
		1:
			pop = HP.instantiate()
		2:
			pop = SHIELD.instantiate()
		3:
			pop = SHOOT_POWER_UP.instantiate()
		4:
			pop = SHOOT_SPEED_UP.instantiate()
		5:
			pop = SPEEDUP.instantiate()
	pop.position = path_follow_2d.global_position
	get_tree().root.add_child(pop)
	print("spawn")
	pass
