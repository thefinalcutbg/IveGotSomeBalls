extends Node2D

@onready var labels = [$L4, $L5, $L1, $L2, $L3]



# Called when the node enters the scene tree for the first time.
func _ready():
	print("labels ready")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if !direction:
		direction = Input.get_axis("ui_up", "ui_down")

	move()
	
	pass


var frame_counter = 0
var direction = 0

func move():
	
	if direction == 0: return

	if frame_counter == 32: 
		if direction == 1:
			labels.push_front(labels.pop_back())
			labels.front().position.y = -64
		elif direction == -1:
			labels.push_back(labels.pop_front())
			labels.back().position.y = 192
			
		direction = 0
		frame_counter = 0
		return
	
	for n in labels.size():
		labels[n].position.y += 2*direction
	
	frame_counter+=1
	
