extends Node3D

func set_player_parameters(player):
	#player.gravity_scale = 1.2
	#player.physics_material_override.bounce = 0.4
	#player.set_thunder_range(15)
	pass

func _ready():
	$Gate.set_powerup(Globals.POWERUP.JUMP)

func _physics_process(delta):
	pass
