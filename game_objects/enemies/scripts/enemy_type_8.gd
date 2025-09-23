extends Enemy

var damage: int = 25
@onready var trail: Node = $TrailScriptHolder

func toggle_trail_effect():
	trail.is_need_trails = !trail.is_need_trails
