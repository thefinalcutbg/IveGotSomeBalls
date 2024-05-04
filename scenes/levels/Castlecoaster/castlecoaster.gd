extends Node3D

func set_player_parameters(player):
	player.gravity_scale = 1.2
	player.physics_material_override.bounce = 0.4

	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	$AccelerationArea.set_vector(Vector3(0,0-0.3,-1))
	$AccelerationArea.coef = 90
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$castlecoaster/arrow1.rotate_x(0.03)
	$castlecoaster/arrow2.rotate_x(0.03)
