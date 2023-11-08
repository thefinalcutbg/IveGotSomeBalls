extends VBoxContainer

const LABEL = preload("res://scenes/menu/Label.tscn")

var _index = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	set_type(Globals.INGAME_MENU_TYPE.PLAYING)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func set_type(type):
	
	var labelText = [
		"CONTINUE TO THE NEXT LEVEL",
		"RESUME LEVEL",
		"RESTART LEVEL",
		"QUIT TO MAIN MENU"
		]
	get_tree().paused = true
	match type:
		Globals.INGAME_MENU_TYPE.PLAYING:
			$SubMenu.add_label("L1", labelText[1])
		Globals.INGAME_MENU_TYPE.WIN:
			$SubMenu.add_label("L0", labelText[0])
			
	$SubMenu.add_label("L2", labelText[2])
	$SubMenu.add_label("L3", labelText[3])
	$SubMenu.scroll = false
