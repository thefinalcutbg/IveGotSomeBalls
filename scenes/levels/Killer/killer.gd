extends Node3D

var max_heigh
var max_low = -1.5
func set_player_parameters(player):
	player.jump_coef = [3,3.5,4.5,5.6]
	#player.physics_material_override.bounce = 0.4
	#player.set_thunder_range(15)
	pass

#positive for up, negative for down
var direction = -1

func _ready():
	max_heigh = $killer/platform.position.y
	$Gate.set_powerup(Globals.POWERUP.JUMP)

func _physics_process(delta):
	
	var current_pos = $killer/platform.position.y
	
	if current_pos > max_heigh: direction = -1
	elif current_pos < max_low: direction = 1
	
	
	$killer/platform.position.y = current_pos + direction  * 0.005
	
	pass
