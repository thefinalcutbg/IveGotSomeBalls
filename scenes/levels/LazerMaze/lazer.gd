extends Node3D

@onready var barriers = $Barriers
# Called when the node enters the scene tree for the first time.
func _ready():
	$Gate.set_powerup(Globals.POWERUP.BREAK)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	$lazer/propeller.rotate_y(-0.0125)
	$lazer/propeller1.rotate_z(-0.005)
	$lazer/propeller3.rotate_z(-0.005)
	$lazer/propeller5.rotate_z(-0.005)
	$lazer/propeller7.rotate_z(-0.005)
	$lazer/propeller2.rotate_z(+0.005)
	$lazer/propeller4.rotate_z(+0.005)
	$lazer/propeller6.rotate_z(+0.005)
	$lazer/propeller8.rotate_z(+0.005)

func set_player_parameters(player):
	player.physics_material_override.bounce = 0.4

	$lazer/propeller/StaticBody3D.constant_angular_velocity.y = -10
	$lazer/propeller1/StaticBody3D.constant_angular_velocity.z = -5
	$lazer/propeller3/StaticBody3D.constant_angular_velocity.z = -5
	$lazer/propeller5/StaticBody3D.constant_angular_velocity.z = -5
	$lazer/propeller7/StaticBody3D.constant_angular_velocity.z = -5
	$lazer/propeller2/StaticBody3D.constant_angular_velocity.z = +5
	$lazer/propeller4/StaticBody3D.constant_angular_velocity.z = +5
	$lazer/propeller6/StaticBody3D.constant_angular_velocity.z = +5
	$lazer/propeller8/StaticBody3D.constant_angular_velocity.z = +5

