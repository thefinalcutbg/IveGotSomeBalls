extends Control

const LABEL = preload("res://scenes/menu/label.tscn")

var scroll = true
var offset_y = 0

var _current_index = -1
var _target_index = 0
var _direction = 0
var _frame_counter = 0
var disable_input = false

func _ready():
	pass # Replace with function body.

signal option_selected(index)
signal menu_canceled()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if disable_input: return
	
	if Input.is_action_just_pressed("ui_cancel"):
		menu_canceled.emit()
	
	if !get_child_count(): return
	
	if _current_index == _target_index: #animation is not in progress
		
		_direction = Input.get_axis("ui_up", "ui_down")
	
		var max = get_child_count()-1
		
		#normalizing in case of analog stick
		if _direction < 0: _direction = -1
		elif _direction >0: _direction = 1
		
		if _direction == 1 and _current_index == max:
			_target_index = 0
		elif _direction == -1 and _current_index == 0:
			_target_index = max
		else: _target_index += _direction
		
	else:
		_animate()

	if Input.is_action_just_pressed("ui_select"):
		option_selected.emit(_target_index)


func setCurrentIndex(index):
	if index < 0 or index >= get_child_count(): return
	
	_current_index = index
	_target_index = index
	
	for child in get_children():
		child.deselect()
	
	get_child(index).select()

func _animate():

	if _direction == 0: return
	
	#the animation has just finished
	if _frame_counter == 64:
		_current_index = _target_index
		_direction = 0
		_frame_counter = 0
		return
	
	var _reloop = _target_index != _current_index+_direction
	
	if _frame_counter==0: 
		get_child(_current_index).deselect()
		get_child(_target_index).select()
		if _reloop: 
			_handle_reloop()
			_frame_counter+=32
	
	if !_reloop and scroll:
		for child in get_children():
			child.position.y -= _direction
	
	_frame_counter+=1
	
func add_label(text):
	
	var label = LABEL.instantiate()
	label.text = text
	
	var labelCount = get_child_count()
	
	add_child(label)
	label.position.y = labelCount*64+offset_y
	
	if !labelCount:
		label.select()

func change_current_text(text):
	get_child(_current_index).text = text

func clear():
	
	for n in get_children():
		remove_child(n)
		n.queue_free()
	
	_current_index = 0
	_target_index = 0
	_direction = 0
	_frame_counter = 0


func _handle_reloop():
	
	if !scroll: return
	
	var pos_y = offset_y-(64*_target_index)
	
	for label in get_children():
		label.position.y = pos_y
		pos_y += 64
		
func set_label_text(index, text):
	get_child(index).text = text

func get_label_text(index)->String:
	
	if index < 0 or index >= get_child_count():
		return ""
		
	return get_child(index).text
