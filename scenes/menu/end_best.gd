extends Control

enum STATE {BEGIN, INPUT, END}

var _state : STATE = STATE.BEGIN

signal input_name_finished(text)

func _ready():
	
	$Label.label_settings.font_color = Color.TOMATO
	$Label2.label_settings.font_color = Color.TOMATO
	
	$Label.visible = false
	$EndBest.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	match _state:
		STATE.BEGIN: _process_begin()
		STATE.END: _process_end()


func _process_begin():
	
	$Label2.scale.x +=0.07
	$Label2.scale.y +=0.07
	$Label2.label_settings.font_color.a -= 0.003
	
	if $Label2.label_settings.font_color.a < 0.6:
		$Label.visible = true
		_state = STATE.INPUT

func _process_end():
	
	$Label2.scale.x +=0.05
	$Label2.scale.y +=0.05
	$Label2.label_settings.font_color.a -= 0.006
	
	$Label.scale.x +=0.05
	$Label.scale.y +=0.05
	$Label.label_settings.font_color.a -= 0.006
	
	if $Label.label_settings.font_color.a < 0:
		input_name_finished.emit($Label.text.substr(18, -1).to_upper())
		queue_free()
	
func _input(event):
	
	if _state != STATE.INPUT: return
	
	if event is InputEventKey and event.is_pressed():
			
			#delete characted
			if event.keycode == KEY_ESCAPE:
				var text = $Label.text
				if text.length() <= 18: return
				$Label.text = text.left(text.length() - 1)
				return
			
			#add character
			var input = char(event.unicode)
			
			var regex = RegEx.new()
			
			regex.compile("[a-zA-Z]+")
			
			if !regex.search(input): return
			
			$Label.text = $Label.text + char(event.unicode)
			#3 char name max
			if $Label.text.length() == 21:
				_state = STATE.END
