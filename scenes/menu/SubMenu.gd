extends Control

const LABEL = preload("res://scenes/menu/Label.tscn")

const offset = 220
var current_index = 0
var target_index = 0
var main_menu
var direction = 0

func set_main_menu(menu):
	main_menu = menu


func _ready():
	add_label("lala", "gudsadasdgu")
	add_label("lala", "gudsadasdasdadsaagu")
	add_label("lala", "gudasdasdasdasdasdasgu")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if !animation_in_progress():
		direction = Input.get_axis("ui_up", "ui_down")
		calculate_target_index(direction)
	else:
		animate()
	
	if Input.is_key_label_pressed(KEY_ESCAPE):
		main_menu.close_submenu()

var frame_counter = 0

func animate():

	if direction == 0: return

	#the animation has just finished
	if frame_counter == 16:
		current_index = target_index
		direction = 0
		frame_counter = 0
		return
	
	var reloop = target_index != current_index+direction
	
	if frame_counter==0: 
		get_child(current_index).deselect()
		get_child(target_index).select()
		if reloop: handle_reloop()
			
	
	if !reloop:
		for child in get_children():
			child.position.y -= 4*direction
	
	frame_counter+=1
	
func add_label(name, text):
	
	var label = LABEL.instantiate()
	label.name = name
	label.text = text
	
	var labelCount = get_child_count()

	
	add_child(label)
	label.position.y = labelCount*64+offset
	
	if !labelCount:
		label.select()


func animation_in_progress():
	return current_index != target_index

func calculate_target_index(dir):
	
		var max = get_child_count()-1
		
		if direction == 1 and current_index == max:
			target_index = 0
			return
			
		if direction == -1 and current_index == 0:
			target_index = max
			print(target_index)
			return
		
		target_index += dir


func handle_reloop():

	var pos_y = offset-(64*target_index)
	
	for label in get_children():
		label.position.y = pos_y
		pos_y += 64
		
