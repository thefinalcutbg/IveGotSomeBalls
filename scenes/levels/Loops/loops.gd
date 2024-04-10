extends Node3D

func set_player_parameters(player):
	player.gravity_scale = 0.9
	player.physics_material_override.bounce = 0.3
