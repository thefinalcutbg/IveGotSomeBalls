extends Node3D


func set_player_parameters(player):
	
	$Platform1/Piston/Wing.constant_angular_velocity.x = -2
	$Platform2/Piston/Wing.constant_angular_velocity.z = -2
	$Platform3/Piston/Wing.constant_angular_velocity.x = 2
	
	#player.physics_material_override.bounce = 0.5
	#player.gravity_scale = 0.85

func _physics_process(delta):

	$Platform1/Piston.rotate_x(-0.0128)
	$Platform2/Piston.rotate_x(-0.0128)
	$Platform3/Piston.rotate_x(-0.0128)
