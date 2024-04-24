extends Node3D

@onready var barriers = $Barriers
# Called when the node enters the scene tree for the first time.
func _ready():
	$Gate.set_powerup(Globals.POWERUP.BREAK)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	barriers.get_child(0).rotate_y(-0.025)
	
	barriers.get_child(1).rotate_z(+0.01)
	barriers.get_child(2).rotate_z(+0.01)
	barriers.get_child(3).rotate_z(+0.01)
	barriers.get_child(4).rotate_z(+0.01)
	barriers.get_child(5).rotate_z(-0.01)
	barriers.get_child(6).rotate_z(-0.01)
	barriers.get_child(7).rotate_z(-0.01)
	barriers.get_child(8).rotate_z(-0.01)

func set_player_parameters(player):
	player.physics_material_override.bounce = 0.4
	
	barriers.get_child(0).constant_angular_velocity.y = -4
	barriers.get_child(1).constant_angular_velocity.z = 2
	barriers.get_child(2).constant_angular_velocity.z = 2
	barriers.get_child(3).constant_angular_velocity.z = 2
	barriers.get_child(4).constant_angular_velocity.z = 2
	barriers.get_child(5).constant_angular_velocity.z = -2
	barriers.get_child(6).constant_angular_velocity.z = -2
	barriers.get_child(7).constant_angular_velocity.z = -2
	barriers.get_child(7).constant_angular_velocity.z = -2
