extends Node3D

var _diamond_count = 0
var game_state := Globals.GAME_STATE.PLAYING
var _level_path : String
var _level_name : String
var _level_best : float
var total_playtime : float = 0


const LEVELLABEL = preload("res://scenes/game/level_label.tscn")
const ENDBEST = preload("res://scenes/menu/end_best.tscn")
signal menu_requested()

func _ready():
	$Audio/GameMusic.play()
	pass

func _process(delta):
	_update_hud()
	
func _physics_process(delta):
	
	if _diamond_count:
		total_playtime += delta
	
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
	
	_setDeathZone(level)
	
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
	
	#getting highscore
	var score = get_highscore(_level_name)
	
	_level_best = score[0]
	
	$HUD/Best.text = "BEST: " + str(score[0]).pad_decimals(2) + " " + score[1]
	
	$HUD/Timer.reset()

func open_ingame_menu(menu):
	add_child(menu)

func diamond_collected(play_sound):
	
	#_diamond_count = 0
	_diamond_count -= 1
	
	$HUD/Diamonds.text = str(_diamond_count)
	
	if play_sound:
		$Audio/DiamondSound.play()
	
	if _diamond_count != 0: return
	
	game_state = Globals.GAME_STATE.LEVEL_COMPLETED
	
	$HUD/Timer.stop()
	
	_end_game()

const THUNDER_BOLT = preload("res://scenes/game/thunder_bolt.tscn")

func show_speedrun():
	$HUD/Speedrun.visible = true

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
	
	var time = total_playtime
	
	var mins = int(time) / 60
	time -= mins * 60
	var secs = int(time) 
	var mili = int((time - int(time)) * 100)
	
	$HUD/Speedrun.text = "SPEEDRUN: " + str("%0*d" % [2, mins]) + ":" + str("%0*d" % [2, secs]) + ":" + str("%0*d" % [2, mili])
	
func _create_label(text : String, color : Color):
	var label = LEVELLABEL.instantiate()
	label.set_text(text)
	label.set_color(color)
	add_child(label)

func _end_game():
	
	if _level_best == 0 or $HUD/Timer.time_elapsed < _level_best:
		var best = ENDBEST.instantiate()
		best.input_name_finished.connect(_input_name_finished)
		add_child(best)
	else:
		_create_label("LEVEL\nCOMPLETED", Color("GREEN"))
		$Audio/EndSound.play()

func _on_death_area_body_entered(body):
	
	if _diamond_count == 0: return
	
	game_state = Globals.GAME_STATE.GAME_OVER
	menu_requested.emit()

func _on_end_sound_finished():
	menu_requested.emit()

func _input_name_finished(text):
	_save_highscore(_level_name, $HUD/Timer.time_elapsed, text)
	menu_requested.emit()

func _on_game_music_finished():
	$Audio/GameMusicLoop.play()

func _save_highscore(level_name, time, initials):
	
	var highscores = Globals.get_highscores()
	
	highscores[level_name] = [time, initials]
	
	var file = FileAccess.open("user://scores.json", FileAccess.WRITE)
	
	file.store_string(JSON.stringify(highscores))


func get_highscore(level_name):
	
	var highscores = Globals.get_highscores()
	
	if highscores.has(level_name):
		return highscores[level_name]
	
	return [0.00, "???"]

func _setDeathZone(node):
	#to implement...
	for N in node.get_children():
		
		if N.get_child_count() > 0:
			_setDeathZone(N)
		
		if N is MeshInstance3D:
			print(N.get_aabb())
