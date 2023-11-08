extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func select():
	label_settings.font_color = Color.TOMATO

func deselect():
	label_settings.font_color = Color("b1f3ff")

