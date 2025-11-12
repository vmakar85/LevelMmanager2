extends MarginContainer

@onready var flow_container: FlowContainer = $ForkPanel/ForkScrollContainer/FlowContainer


func setup(formation: FormationResource, enemy_id ):
	var overrides = formation.get_overrides_by_key(enemy_id)
	for ovr in overrides:
		var fork_card: PackedScene = load("res://editor/scenes/fork_card.tscn")
		var fork_card_i = fork_card.instantiate()
		flow_container.add_child(fork_card_i)
		ovr.get_powerup_name()
		var o_overrided_id = ovr.get_enemy_overrided_id()
		var o_powerup_name = ovr.get_powerup_name()
		var o_health = ovr.get_health()
		var o_points = ovr.get_points()
		fork_card_i.setup(formation,o_overrided_id,o_health,o_points,o_powerup_name)

func refresh_fork_flow_container():
	pass
