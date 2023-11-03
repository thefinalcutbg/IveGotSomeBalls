extends AudioStreamPlayer

var sounds = [
	0, 
	load("res://assets/audio/byellow.wav"),
	load("res://assets/audio/bgreen.wav"),
	load("res://assets/audio/bred.wav"),
	load("res://assets/audio/bblue.wav")
	]

func play_sound(powerup):
	
	stream = sounds[powerup]
	play()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
