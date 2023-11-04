extends Node3D

const GAME = preload("res://scenes/game/game.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_game():
	$MainMenu.queue_free()
	add_child(GAME.instantiate())
