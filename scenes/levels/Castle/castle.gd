extends Node3D

func set_player_parameters(player):
	#player.gravity_scale = 0.8
	player.physics_material_override.bounce = 0.4
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
