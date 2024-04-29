extends SpotLight3D

var color_forward :bool = true

func _process(delta):
	
	if color_forward: 
		light_color.h = light_color.h + 0.01
	else:
		light_color.h = light_color.h - 0.01
	
	if light_color.h == 1:
		color_forward = false
	elif light_color.h == 0:
		color_forward = true
