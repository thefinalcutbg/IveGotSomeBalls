extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$Gates/Gate1.set_powerup(Globals.POWERUP.JUMP)
	$Gates/Gate2.set_powerup(Globals.POWERUP.THUNDER)
	$Gates/Gate3.set_powerup(Globals.POWERUP.SPEED)
	$Gates/Gate4.set_powerup(Globals.POWERUP.BREAK)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
