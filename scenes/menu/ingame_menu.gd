extends Control

var _option_arr := []
var _current_index :int = 0

const LABEL = preload("res://scenes/menu/label.tscn")

signal option_selected(index)

func _process(delta):

	if Input.is_action_just_pressed("ui_select"):
		option_selected.emit(_option_arr[_current_index])
		return

	#processing direction
	var direction := 0
	
	if Input.is_action_just_pressed("ui_up"): direction = -1
	
	if Input.is_action_just_pressed("ui_down"): direction = 1
	
	if direction == 0: return
	
	var max = _option_arr.size()-1
	
	if direction == 1 and _current_index == max:
		_select_label(0)
	elif direction == -1 and _current_index == 0:
		_select_label(max)
	else: _select_label(_current_index + direction)
	
func add_label(text, option):
	
	var label = LABEL.instantiate()
	label.text = text
	
	label.set_font_size(60)
	
	var labelCount = $VBoxContainer.get_child_count()
	
	$VBoxContainer.add_child(label)
	
	if !labelCount:
		label.select()
		
	_option_arr.push_back(option)

func _select_label(index):
	
	for l in $VBoxContainer.get_children():
		l.deselect()
		
	$VBoxContainer.get_child(index).select()
	
	_current_index = index

func set_selected(label_name):
	
	for i in $VBoxContainer.get_child_count():
		if $VBoxContainer.get_child(i).get_text() == label_name:
			_select_label(i)
			return
