extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$Gates/Gate1.set_powerup(1)
	$Gates/Gate2.set_powerup(4)
	$Gates/Gate3.set_powerup(3)
	$Gates/Gate4.set_powerup(2)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
