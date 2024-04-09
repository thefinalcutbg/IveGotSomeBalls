extends Label

func select():
	label_settings.font_color = Color.TOMATO

func deselect():
	label_settings.font_color = Color("b1f3ff")
	
func set_font_size(size):
	label_settings.font_size = size
