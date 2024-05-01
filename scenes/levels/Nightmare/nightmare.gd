extends Node3D

func set_player_parameters(player):
	player.jump_coef = [3.5,4.5,5.5]
	#player.physics_material_override.bounce = 0.5
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready():
	$Gate.set_powerup(Globals.POWERUP.JUMP)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
