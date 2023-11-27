extends Node3D

const SUBMENU = preload("res://scenes/menu/SubMenu.tscn")
const LEVELLABEL = preload("res://scenes/game/LevelLabel.tscn")

const levels = [
	preload("res://scenes/game/levels/LazerMaze.tscn"),
	preload("res://scenes/game/levels/Chase.tscn"),
	preload("res://scenes/game/levels/Loops.tscn"),
]
var _time = 0.0
var current_level
var current_index = 0
var diamondCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	load_level()

	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.


func load_level():
	
	if current_level:
		current_level.queue_free()
	
	remove_child(current_level)
	
	current_level = levels[current_index].instantiate()
	_create_label(current_level.name, Color("DODGERBLUE"))
	
	add_child(current_level)
	
	var diamonds = get_tree().get_nodes_in_group("Diamonds")

	diamondCount = diamonds.size()
	$HUD/Left.text = str(diamondCount)
	
	for d in diamonds:
		d.set_game(self)
		print("d pos:", d.position)
	
	$Player.respawn()
	_time = 0.0
	

func diamond_collected():
	diamondCount -= 1
	$HUD/Left.text = str(diamondCount)
	print("diamondCount")
	if !diamondCount: level_completed()

func _process(delta):
	
	if diamondCount > 0:
		_time += delta
	
	if Input.is_action_just_pressed("ui_cancel"):
		if diamondCount != 0: open_ingame_menu()
	
	_update_hud()


func spawn_thunder(player, diamond):
	
	const THUNDER_SCENE = preload("res://scenes/game/objects/thunder_bolt.tscn")
	
	var thunder = THUNDER_SCENE.instantiate()
	thunder.set_connectors(player, diamond)
	add_child(thunder)
	$ThunderSound.play()
	
func _on_death_area_area_entered(area):
	#the level is completed
	if !diamondCount: return
	
	diamondCount = -1
	open_ingame_menu()


func _update_hud():
	
	var playerSpeed = str($Player.linear_velocity.length()).pad_decimals(0)
	
	$HUD/Speed.text = "SPEED: " + playerSpeed + "KMH"
	$HUD/Time.text = "TIME: " + str(_time).pad_decimals(2)
	

#MENU LOGIC

func close_menu_requested():

	#game is in progress
	if diamondCount < 1: return
	$MenuCanavas.get_child(0).queue_free()
	get_tree().paused = false

enum MENU_OPTIONS{
	CONTINUE,
	RESUME,
	RESTART,
	EXIT
}

var _choices = []

func open_ingame_menu():
		
		#menu is already opened
		if $MenuCanavas.get_child_count() == 1: return
		var subMenu = SUBMENU.instantiate()

		subMenu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
		subMenu.set_param(self, Globals.MENU_TYPE.INGAME)
		subMenu.offset_y = -120
		subMenu.scroll = false
		$MenuCanavas.add_child(subMenu)
		
		var can_continue = _choices.size() and _choices[0] == MENU_OPTIONS.CONTINUE
		
		_choices.clear()
		
		if !diamondCount or can_continue:
			subMenu.add_label("CONTINUE TO THE NEXT LEVEL")
			_choices.push_back(MENU_OPTIONS.CONTINUE)
			
		if diamondCount > 0:
			subMenu.add_label("RESUME GAME")
			_choices.push_back(MENU_OPTIONS.RESUME)
		
		subMenu.add_label("RESTART LEVEL")
		_choices.push_back(MENU_OPTIONS.RESTART)
		
		subMenu.add_label("EXIT TO MAIN MENU")
		_choices.push_back(MENU_OPTIONS.EXIT)
		
		get_tree().paused = true


func option_selected(index):
	
	$MenuCanavas.get_child(0).queue_free()
	get_tree().paused = false
	
	match _choices[index]:
		MENU_OPTIONS.CONTINUE: 
			_choices.clear()
			current_index+=1
			load_level()
		MENU_OPTIONS.RESUME:
			return
		MENU_OPTIONS.RESTART:
			load_level()
		MENU_OPTIONS.EXIT:
			get_parent().quit_to_menu()

func level_completed():
	#put high score logic here
	
	var bestTime = false
	
	var color
	var text
	var sound

	if bestTime:
		text = "BEST\nTIME"
		color = Color("RED")
		sound = load("res://assets/audio/endbest.wav")
	else:
		text = "LEVEL\nCOMPLETED"
		color = Color("GREEN")
		sound = load("res://assets/audio/end.wav")
	
	_create_label(text, color)

	$EndSound.stream = sound
	$EndSound.play()

func _on_end_sound_finished():
	open_ingame_menu()

func _create_label(text, color):
	
	var label = LEVELLABEL.instantiate()
	label.set_text(text)
	label.set_color(color)
	$MenuCanavas.add_child(label)
