extends Node3D

const GAME = preload("res://scenes/game/game.tscn")
const MENU = preload("res://scenes/menu/main_menu.tscn")
const INGAME_MENU = preload("res://scenes/menu/ingame_menu.tscn")

var _menu_scene

var _level_index = -1
var _can_continue = false

func _game():
	return get_node("Game")

func _ready():
	_play_main_menu_music()
	add_child(MENU.instantiate())


func _create_game():
	
	_stop_main_menu_music()
	
	_menu_scene = get_child(1)
	remove_child(get_child(1))
	
	var game = GAME.instantiate()
	
	add_child(game)
	
	game.menu_requested.connect(_menu_requested)
	
func start_game(): 
	
	_level_index = 0
	
	_create_game()
	
	_game().load_level(Globals.CAMPAIGN[_level_index])

func play_level(index):
	
	_level_index = -1
	
	_create_game()
	
	_game().load_level(Globals.SINGLE_LEVEL[index])


func _play_main_menu_music():
	$MfBallsAudio.play()

func _on_mf_balls_audio_finished():
	$MfBallsAudio/MenuLoopAudio.play()

func _stop_main_menu_music():
	$MfBallsAudio.stop()
	$MfBallsAudio/MenuLoopAudio.stop()


enum MenuChoice {
	RESUME,
	RESTART,
	QUIT,
	CONTINUE
}

func _menu_requested():
	
	var ingameMenu = INGAME_MENU.instantiate()
	
	#ADDING CONTINUE LABEL
	if _can_continue or _game().game_state == Globals.GAME_STATE.LEVEL_COMPLETED:
		if _level_index != -1 :
			_can_continue = true
			ingameMenu.add_label("Continue to Next Level", MenuChoice.CONTINUE)
	
	#ADDING RESUME LABEL
	if _game().game_state == Globals.GAME_STATE.PLAYING:
			ingameMenu.add_label("Return to game", MenuChoice.RESUME)
	
	#ADDING THE OTHER LABELS
	ingameMenu.add_label("Restart level", MenuChoice.RESTART)
	ingameMenu.add_label("Quit to menu", MenuChoice.QUIT)
	
	ingameMenu.option_selected.connect(_process_menu_choice)
	
	_game().open_ingame_menu(ingameMenu)
	
	get_tree().paused = true
	
func _process_menu_choice(option):
	
	match option:
		
		MenuChoice.CONTINUE:
			if _level_index == Globals.CAMPAIGN.size()-1:
				_level_index = -1
				_game().queue_free()
				add_child(_menu_scene)
				_play_main_menu_music()
			else:
				_can_continue = false
				_level_index += 1
				_game().close_ingame_menu()
				_game().load_level(Globals.CAMPAIGN[_level_index])
				
		MenuChoice.RESUME: 
			_game().close_ingame_menu()
			
		MenuChoice.RESTART:
			_game().close_ingame_menu()
			_game().start_game()
			
		MenuChoice.QUIT:
			_level_index = -1
			_game().queue_free()
			add_child(_menu_scene)
			_play_main_menu_music()

	get_tree().paused = false
