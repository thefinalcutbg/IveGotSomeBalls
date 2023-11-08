extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_text(text):
	$Label.text = text
	
func set_color(color):
	$Label.label_settings.font_color = color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if $Label.label_settings.font_color.a < 0: 
		queue_free()
	
	$Label.scale.x +=0.1
	$Label.scale.y +=0.1
	$Label.label_settings.font_color.a -= 0.013

