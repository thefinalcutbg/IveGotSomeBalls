extends Node3D

const GAME = preload("res://scenes/game/game.tscn")
const MENU = preload("res://scenes/menu/main_menu.tscn")
const WINSCREEN = preload("res://scenes/game/win_screen.tscn")
const INGAME_MENU = preload("res://scenes/menu/ingame_menu.tscn")

var _menu_scene

var _level_index = -1
var _can_continue = false

func _game():
	return get_node("Game")
	
func _current_scene():
	return get_child(2)

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	_play_main_menu_music()
	add_child(MENU.instantiate())


func _create_game():
	
	_play_game_music()
	
	_menu_scene = get_child(2)
	remove_child(get_child(2))
	
	var game = GAME.instantiate()
	
	add_child(game)
	
	game.menu_requested.connect(_menu_requested)
	
func start_game(): 
	
	_level_index = 0
	
	_create_game()
	
	_game().load_level(Globals.CAMPAIGN[_level_index])
	
	_game().show_speedrun()

func play_level(level_name):
	
	if !Globals.LEVEL_MAP.has(level_name): return
	
	_level_index = -1
	
	_create_game()
	
	_game().load_level(level_name)


func _play_main_menu_music():
	$GameMusic.stop()
	$GameMusic/GameMusicLoop.stop()
	$MfBallsAudio.play()
	

func _play_game_music():
	$MfBallsAudio.stop()
	$MfBallsAudio/MenuLoopAudio.stop()
	$GameMusic.play()

func _on_mf_balls_audio_finished():
	$MfBallsAudio/MenuLoopAudio.play()
	
func _on_game_music_finished():
	$GameMusic/GameMusicLoop.play()

enum MenuChoice {
	RESUME,
	RESTART,
	QUIT,
	CONTINUE
}

func _menu_requested():
	
	var ingameMenu = INGAME_MENU.instantiate()
	
	var continue_label_added = false
	
	#ADDING CONTINUE LABEL
	if _can_continue or _game().game_state == Globals.GAME_STATE.LEVEL_COMPLETED:
		if _level_index != -1 :
			_can_continue = true
			ingameMenu.add_label("Continue to Next Level", MenuChoice.CONTINUE)
			continue_label_added = true
	
	#ADDING RESUME LABEL
	if _game().game_state == Globals.GAME_STATE.PLAYING:
			ingameMenu.add_label("Return to game", MenuChoice.RESUME)
	
	#ADDING THE OTHER LABELS
	ingameMenu.add_label("Restart level", MenuChoice.RESTART)
	ingameMenu.add_label("Quit to menu", MenuChoice.QUIT)
	
	ingameMenu.set_selected("Return to game")
	
	ingameMenu.option_selected.connect(_process_menu_choice)
	
	_game().open_ingame_menu(ingameMenu)
	
	get_tree().paused = true
	
func _process_menu_choice(option):
	
	match option:
		
		MenuChoice.CONTINUE:
			#game finished
			if _level_index == Globals.CAMPAIGN.size()-1:
				var win_screen = WINSCREEN.instantiate()
				win_screen.set_time(_game().total_playtime)
				_game().queue_free()
				add_child(win_screen)
			#next level:
			else:
				_can_continue = false
				_level_index += 1
				_game().load_level(Globals.CAMPAIGN[_level_index])
				_game().close_ingame_menu()
				
		MenuChoice.RESUME: 
			_game().close_ingame_menu()
			
		MenuChoice.RESTART:
			_game().close_ingame_menu()
			_game().start_game()
			
		MenuChoice.QUIT:
			return_to_main_menu()

	get_tree().paused = false

func return_to_main_menu():
	
	_level_index = -1
	_can_continue = false
	
	#could be game or win screen
	_current_scene().queue_free()
	
	add_child(_menu_scene)
	
	_play_main_menu_music()
