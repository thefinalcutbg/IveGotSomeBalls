extends Node3D

const SUBMENU = preload("res://scenes/menu/SubMenu.tscn")
const LEVELLABEL = preload("res://scenes/game/LevelLabel.tscn")
const levels = [
	preload("res://scenes/game/levels/testLevel.tscn"),
	preload("res://scenes/game/levels/Test2.tscn")
]

var current_level
var current_index = -1
var diamondCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.set_camera($Camera)
	
	load_level()

	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.

func load_next_level():
	current_index+=1
	load_level()
	pass
	
func restart_level():
	load_level()
	pass
	
func quit_to_menu():
	get_parent().quit_to_menu()
	pass
	
func load_level():
	
	if current_level:
		current_level.queue_free()

	current_level = levels[current_index].instantiate()
	_create_label(current_level.name, Color("DODGERBLUE"))
	add_child(current_level)
	var diamondNode = current_level.find_child("Diamonds")
	diamondCount = diamondNode.get_child_count()
	
	for d in diamondNode.get_children():
		d.set_game(self)
	
	$Player.respawn()

func diamond_collected():
	diamondCount -= 1
	print(diamondCount)

	if !diamondCount: level_completed()

func _process(delta):
	
	if Input.is_action_just_pressed("ui_cancel"):
		if diamondCount != 0: open_ingame_menu()


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

#MENU LOGIC

func close_ingame_menu():
	$MenuCanavas.get_child(0).queue_free()
	get_tree().paused = false

func close_menu_requested():
	#game in progress
	if diamondCount > 0: close_ingame_menu()


func open_ingame_menu():
	
		#menu is already opened
		if $MenuCanavas.get_child_count(): return
#
		var subMenu = SUBMENU.instantiate()

		subMenu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
		
		subMenu.offset_y = -120
		$MenuCanavas.add_child(subMenu)
		
		match diamondCount:
			-1:
				subMenu.set_param(self, int(Globals.MENU_TYPE.INGAME_DEATH))
			0: 
				subMenu.set_param(self, int(Globals.MENU_TYPE.INGAME_WIN))
				subMenu.add_label("CONTINUE TO THE NEXT LEVEL")
			_: 
				subMenu.set_param(self, int(Globals.MENU_TYPE.INGAME_PLAY))
				subMenu.add_label("RESUME GAME")
			
		subMenu.add_label("RESTART LEVEL")
		subMenu.add_label("EXIT TO MAIN MENU")
		
		subMenu.scroll = false
#
		get_tree().paused = true

func option_selected(index):
	
	close_ingame_menu()
	
	index = int(index)

	if diamondCount > 0:
		match index:
			0: return
			1: load_level()
			2: quit_to_menu()
	elif diamondCount == -1:
		match index:
			0: load_level()
			1: quit_to_menu()
	elif diamondCount == 0:
		match index:
			0: load_next_level()
			1: load_level()
			2: quit_to_menu()
			
	

func level_completed():
	#put high score logic here
	var color
	var text
	var sound
	
	var bestTime = true
	
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
