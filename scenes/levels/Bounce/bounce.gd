extends Node3D


func set_player_parameters(player):
	
	$bounce/Wing1/StaticBody3D.constant_angular_velocity.x = -2.1
	$bounce/Wing2/StaticBody3D.constant_angular_velocity.z = -2.1
	$bounce/Wing3/StaticBody3D.constant_angular_velocity.x = 2.1
	
	$bounce/Wing1.mesh.surface_get_material(0).albedo_color = "ff7070"
	$bounce/Wing2.mesh.surface_get_material(0).albedo_color = "ff7070"
	$bounce/Wing3.mesh.surface_get_material(0).albedo_color = "ff7070"


func _physics_process(delta):

	$bounce/Wing1.rotate_x(-0.0064)
	$bounce/Wing2.rotate_z(-0.0064)
	$bounce/Wing3.rotate_x(0.0064)
