extends Node3D


func set_player_parameters(player):
	
	$Platform1/Piston/Wing.constant_angular_velocity.x = -2.1
	$Platform2/Piston/Wing.constant_angular_velocity.z = -2.1
	$Platform3/Piston/Wing.constant_angular_velocity.x = 2.1


func _physics_process(delta):

	$Platform1/Piston.rotate_x(-0.0064)
	$Platform2/Piston.rotate_x(-0.0064)
	$Platform3/Piston.rotate_x(-0.0064)
