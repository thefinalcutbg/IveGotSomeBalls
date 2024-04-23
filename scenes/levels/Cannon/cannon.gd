extends Node3D

func set_player_parameters(player):
	player.physics_material_override.bounce = 0.5
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	$Gate.set_powerup(Globals.POWERUP.THUNDER)
