extends SpotLight3D


# Called when the node enters the scene tree for the first time.

var color_forward :bool = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if color_forward: 
		light_color.h = light_color.h + 0.01
	else:
		light_color.h = light_color.h - 0.01
	
	print(light_color.h)
	
	if light_color.h == 1:
		color_forward = false
	elif light_color.h == 0:
		color_forward = true
