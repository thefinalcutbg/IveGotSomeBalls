extends Node3D

@onready var barriers = $Barriers
# Called when the node enters the scene tree for the first time.
func _ready():
	$Gate.set_powerup(Globals.POWERUP.BREAK)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	barriers.get_child(0).rotate_y(-0.05)
	
	barriers.get_child(1).rotate_z(+0.02)
	barriers.get_child(2).rotate_z(+0.02)
	barriers.get_child(3).rotate_z(+0.02)
	barriers.get_child(4).rotate_z(+0.02)
	barriers.get_child(5).rotate_z(-0.02)
	barriers.get_child(6).rotate_z(-0.02)
	barriers.get_child(7).rotate_z(-0.02)

