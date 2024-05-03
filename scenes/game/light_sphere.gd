extends Sprite3D


func set_color(color:Color):
	modulate = color
	$OmniLight3D.light_color = color
