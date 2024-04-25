extends Node3D

var _diamond_count = 0
var game_state := Globals.GAME_STATE.PLAYING
var _level_path : String
var _level_name : String

const LEVELLABEL = preload("res://scenes/game/level_label.tscn")

signal menu_requested()

func _ready():
	$Audio/GameMusic.play()
	pass

func _process(delta):
	_update_hud()
	
func _physics_process(delta):
	
	if Input.is_action_just_pressed("ui_cancel"):
		if game_state != Globals.GAME_STATE.PLAYING: return
		menu_requested.emit()
		return

func load_level(LevelName : String):
	
	_level_path = Globals.LEVEL_MAP[LevelName]
	_level_name = LevelName
	start_game()

func start_game():
	
	game_state = Globals.GAME_STATE.PLAYING

	var level = load(_level_path).instantiate()
	
	_create_label(_level_name, Color("#7199fe"))
	
	if $Level.get_child_count():
		var oldLevel = $Level.get_child(0)
		$Level.remove_child(oldLevel)
		oldLevel.queue_free()
	
	$Level.add_child(level)
	
	var diamonds = get_tree().get_nodes_in_group("Diamonds")
	
	_diamond_count = diamonds.size()
	
	$HUD/Diamonds.text = str(_diamond_count)
	
	for d in diamonds: d.set_game(self)
	
	$Audio/SpawnAudio.play()
	
	$Player.respawn()
	
	if level.has_method("set_player_parameters"):
		level.set_player_parameters($Player)
	
	$HUD/Timer.reset()

func open_ingame_menu(menu):
	add_child(menu)

func diamond_collected():
	
	#_diamond_count = 0
	_diamond_count -= 1
	
	$HUD/Diamonds.text = str(_diamond_count)
	
	$Audio/DiamondSound.play()
	
	if _diamond_count != 0: return
	
	game_state = Globals.GAME_STATE.LEVEL_COMPLETED
	
	$HUD/Timer.stop()
	
	_end_game(false)

const THUNDER_BOLT = preload("res://scenes/game/thunder_bolt.tscn")

func spawn_thunder(player, diamond):
	
	var thunder = THUNDER_BOLT.instantiate()
	thunder.set_connectors(player, diamond)
	add_child(thunder)
	$Audio/ThunderSound.play()

func close_ingame_menu():
	get_node("IngameMenu").queue_free()

func _update_hud():
	
	var playerSpeed = str($Player.linear_velocity.length()).pad_decimals(0)
	
	$HUD/Speed.text = "SPEED: " + playerSpeed + "KMH"
	
	$HUD/FPS.text = "FPS " + str(Engine.get_frames_per_second())
	
func _create_label(text : String, color : Color):
	var label = LEVELLABEL.instantiate()
	label.set_text(text)
	label.set_color(color)
	add_child(label)

func _end_game(best_time : bool)->void:
	
	if best_time:
		_create_label("BEST\nTIME", Color("RED"))
		$Audio/EndBest.play()
	else:
		_create_label("LEVEL\nCOMPLETED", Color("GREEN"))
		$Audio/EndSound.play()

func _on_death_area_body_entered(body):
	
	if _diamond_count == 0: return
	
	game_state = Globals.GAME_STATE.GAME_OVER
	menu_requested.emit()

func _on_end_sound_finished():
	menu_requested.emit()

func _on_end_best_finished():
	#highscore input logic goes here
	menu_requested.emit()

func _on_game_music_finished():
	$Audio/GameMusicLoop.play()
