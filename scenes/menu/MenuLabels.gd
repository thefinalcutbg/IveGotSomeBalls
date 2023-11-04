extends Node2D

@onready var labels = [$Setup, $Quit, $Start, $Select, $Scores]

@onready var main_menu = get_parent().get_parent()

var is_current = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if !is_current: return
	
	if !direction:
		direction = Input.get_axis("ui_up", "ui_down")*-1
		
	move()
	
	if Input.is_key_pressed(KEY_SPACE):
		
		match labels[2].name:
			"Start": main_menu.start_game()
			"Quit": main_menu.quit()
			_: main_menu.open_submenu()
	


var frame_counter = 0
var direction = 0

func move():
	
	if direction == 0: return
	
	if frame_counter == 32:
		direction = 0
		frame_counter = 0
		return
	
	if frame_counter == 0: 
		if direction == 1:
			labels.push_front(labels.pop_back())
			labels.front().position.y = -384
		elif direction == -1:
			labels.push_back(labels.pop_front())
			labels.back().position.y = 768
			
	
	for n in labels.size():
		labels[n].position.y += 6*direction
	
	frame_counter+=1
	

