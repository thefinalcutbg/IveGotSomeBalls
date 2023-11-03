extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var movement = 0.1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if global_position.z > 24: movement = -0.05
	
	if global_position.z < -20: movement = 0.05
	
	global_position.z += movement
