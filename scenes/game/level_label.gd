extends Control

func set_text(text : String):
	$Label.text = text
	
func set_color(color : Color):
	$Label.label_settings.font_color = color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if $Label.label_settings.font_color.a < 0: 
		queue_free()
	
	$Label.scale.x +=0.1
	$Label.scale.y +=0.1
	$Label.label_settings.font_color.a -= 0.013

