extends Node3D

func set_player_parameters(player):
	player.gravity_scale = 1.2
	player.physics_material_override.bounce = 0.4
	#player.set_thunder_range(15)

# Called when the node enters the scene tree for the first time.
func _ready():
	$AccelerationArea.set_vector(Vector3(0,0,-1))
	$AccelerationArea.coef = 6000
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
