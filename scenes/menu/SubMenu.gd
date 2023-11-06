extends Control

const LABEL = preload("res://scenes/menu/Label.tscn")

var scroll = true
var offset_y = 220

var _current_index = 0
var _target_index = 0
var _main_menu
var _direction = 0
var _frame_counter = 0


func set_main_menu(menu):
	_main_menu = menu


func _ready():
	set_process_input(false)
	add_label("lala", "gudsadasdgu")
	add_label("lala", "gudsadasdasdadsaagu")
	add_label("lala", "gudasdasdasdasdasdasgu")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if !animation_in_progress():
		_direction = Input.get_axis("ui_up", "ui_down")
		calculate_target_index(_direction)
	else:
		animate()

	
	if Input.is_key_label_pressed(KEY_ESCAPE):
		_main_menu.close_submenu()

	
	if Input.is_key_label_pressed(KEY_SPACE):
		_main_menu.sub_menu_index_selected(_current_index)


func animate():

	if _direction == 0: return

	#the animation has just finished
	if _frame_counter == 16:
		_current_index = _target_index
		_direction = 0
		_frame_counter = 0
		return
	
	var _reloop = _target_index != _current_index+_direction
	
	if _frame_counter==0: 
		get_child(_current_index).deselect()
		get_child(_target_index).select()
		if _reloop: 
			handle_reloop()
			_frame_counter+=8
	
	if !_reloop and scroll:
		for child in get_children():
			child.position.y -= 4*_direction
	
	_frame_counter+=1
	
func add_label(name, text):
	
	var label = LABEL.instantiate()
	label.name = name
	label.text = text
	
	var labelCount = get_child_count()

	
	add_child(label)
	label.position.y = labelCount*64+offset_y
	
	if !labelCount:
		label.select()


func animation_in_progress():
	return _current_index != _target_index

func calculate_target_index(dir):
	
		var max = get_child_count()-1
		
		if _direction == 1 and _current_index == max:
			_target_index = 0
			return
			
		if _direction == -1 and _current_index == 0:
			_target_index = max
			print(_target_index)
			return
		
		_target_index += dir


func handle_reloop():
	
	if !scroll: return
	
	var pos_y = offset_y-(64*_target_index)
	
	for label in get_children():
		label.position.y = pos_y
		pos_y += 64
		
