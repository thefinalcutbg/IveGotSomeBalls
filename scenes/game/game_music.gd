extends AudioStreamPlayer

func _ready():
	play()

func _on_finished():
	get_child(0).play()
