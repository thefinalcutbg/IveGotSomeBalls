extends Node3D


func set_player_parameters(player):
	#player.gravity_scale = 1.2
	player.physics_material_override.bounce = 0.4
	#player.set_thunder_range(15)

func _ready():
	$rollercoaster/cyl_rotate/StaticBody3D.constant_angular_velocity.z = 3
	$Gate.set_powerup(Globals.POWERUP.THUNDER)

func _physics_process(delta):
	$rollercoaster/cyl_rotate.rotate_z(+0.005)
