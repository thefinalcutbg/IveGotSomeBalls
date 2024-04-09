extends Node2D

@onready var labels = [$Setup, $Quit, $Start, $SingleMap, $Scores]

@onready var main_menu = get_parent().get_parent()

signal option_selected(label_name)

var _frame_counter = 0
var _direction = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var disable_input = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	move()	
	
	if disable_input: return
	
	if !_direction:
		_direction = Input.get_axis("ui_up", "ui_down")*-1
	
	#
	if Input.is_action_just_pressed("ui_select"):
		option_selected.emit(labels[2].name)

func move():
	
	if _direction == 0: return
	
	if _frame_counter == 64:
		_direction = 0
		_frame_counter = 0
		return
	
	if _frame_counter == 0: 
		if _direction == 1:
			labels.push_front(labels.pop_back())
			labels.front().position.y = -256
		elif _direction == -1:
			labels.push_back(labels.pop_front())
			labels.back().position.y = 512
			
	
	for n in labels.size():
		labels[n].position.y += 2*_direction
	
	_frame_counter+=1
	

