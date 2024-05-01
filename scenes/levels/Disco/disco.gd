extends Node3D

func set_player_parameters(player):
	player.physics_material_override.bounce = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	$Gate1.set_powerup(Globals.POWERUP.THUNDER)
	$Accelerator/AccelerationArea.set_vector(Vector3(-1,0,0))
	$Accelerator/AccelerationArea2.set_vector(Vector3(-1,1,0))
	$Accelerator/AccelerationArea.coef = 500
	$Accelerator/AccelerationArea2.coef = 300
	
