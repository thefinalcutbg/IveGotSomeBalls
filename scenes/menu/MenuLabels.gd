extends Node2D

@onready var labels = [$Setup, $Quit, $Start, $Select, $Scores]

@onready var main_menu = get_parent().get_parent()

var frame_counter = 0
var direction = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var disable_input = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	move()	
	
	if disable_input: return
	
	if !direction:
		direction = Input.get_axis("ui_up", "ui_down")*-1
	
	
	if Input.is_action_just_pressed("ui_select"):
		
		match labels[2].name:
			"Start": main_menu.start_game()
			"Select": main_menu.open_submenu(Globals.MENU_TYPE.SINGLE_MAP)
			"Scores": main_menu.open_submenu(Globals.MENU_TYPE.SCORES)
			"Setup": main_menu.open_submenu(Globals.MENU_TYPE.SETUP)
			"Quit": main_menu.quit()

func move():
	
	if direction == 0: return
	
	if frame_counter == 32:
		direction = 0
		frame_counter = 0
		return
	
	if frame_counter == 0: 
		if direction == 1:
			labels.push_front(labels.pop_back())
			labels.front().position.y = -256
		elif direction == -1:
			labels.push_back(labels.pop_front())
			labels.back().position.y = 512
			
	
	for n in labels.size():
		labels[n].position.y += 4*direction
	
	frame_counter+=1
	

