class_name PowerupResource
extends Resource

enum PowerupType {
	HEALUP,
	MOVESPEEDUP,
	SHOOTSPEEDUP,
	SHIELDUP,
	CONTINUEUP,
	SHOOTPOWERUP
}

@export var type: PowerupType
@export var icon: Texture2D
@export var scene: PackedScene
