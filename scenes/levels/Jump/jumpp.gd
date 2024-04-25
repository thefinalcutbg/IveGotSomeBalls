extends Node3D

func set_player_parameters(player):
	#player.gravity_scale = 0.8
	#player.physics_material_override.bounce = 0.4
	pass

func _ready():
	$Gate.set_powerup(Globals.POWERUP.THUNDER)
	$Gate2.set_powerup(Globals.POWERUP.JUMP)
	pass
