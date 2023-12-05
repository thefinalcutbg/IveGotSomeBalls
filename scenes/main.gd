extends Node3D

const GAME = preload("res://scenes/game/game.tscn")
const MENU = preload("res://scenes/menu/MainMenu.tscn")

func _ready():
	add_child(MENU.instantiate())
	Engine.physics_ticks_per_second = 120


func start_game():
	if get_child(0): get_child(0).queue_free()
		
	var game = GAME.instantiate()
	add_child(game)
	game.play_campaign()

func play_level(level):
	
	if get_child(0): get_child(0).queue_free()
		
	var game = GAME.instantiate()
	add_child(game)
	game.play_level(level)
	
func quit_to_menu():
	if get_child(0): get_child(0).queue_free()
	add_child(MENU.instantiate())
	

