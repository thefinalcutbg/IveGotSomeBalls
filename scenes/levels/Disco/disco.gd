extends Node3D

func set_player_parameters(player):
	player.gravity_scale = 1.2
	player.physics_material_override.bounce = 0.4
	player.set_thunder_range(15)


# Called when the node enters the scene tree for the first time.
func _ready():
	$Gate1.set_powerup(Globals.POWERUP.THUNDER)
	$Accelerator/AccelerationArea.set_vector(Vector3(-1,0,0))
	$Accelerator/AccelerationArea2.set_vector(Vector3(-1,1,0))
	$Accelerator/AccelerationArea.coef = 25000
	$Accelerator/AccelerationArea2.coef = 15000
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
