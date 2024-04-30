extends Node3D

func set_player_parameters(player):
	player.physics_material_override.bounce = 0.3
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	#$city/revolve1/StaticBody3D.constant_angular_velocity.x = -1
	$city/revolve2/StaticBody3D.constant_angular_velocity.y = -3
	$city/revolve3/StaticBody3D.constant_angular_velocity.y = 3
	$Gate.set_powerup(Globals.POWERUP.SPEED)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$city/revolve1.rotate_x(+0.005)
	$city/revolve2.rotate_y(-0.0075)
	$city/revolve3.rotate_y(+0.0075)
	pass
