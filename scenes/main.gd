extends Node3D

const GAME = preload("res://scenes/game/game.tscn")
const MENU = preload("res://scenes/menu/MainMenu.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(MENU.instantiate())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_game():
	if get_child(0): get_child(0).queue_free()
	add_child(GAME.instantiate())

func quit_to_menu():
	if get_child(0): get_child(0).queue_free()
	add_child(MENU.instantiate())
	

