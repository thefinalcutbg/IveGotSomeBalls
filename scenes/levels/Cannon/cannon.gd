extends Node3D

func set_player_parameters(player):
	#player.gravity_scale = 0.8
	#player.physics_material_override.bounce = 0.5
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	$AccelerationArea.set_vector(Vector3(0,0,-1))
	$AccelerationArea.coef = 60000
	$Gate.set_powerup(Globals.POWERUP.THUNDER)
