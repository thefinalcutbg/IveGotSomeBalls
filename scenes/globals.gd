extends Node

var show_speedrun : bool = false
var show_fps : bool = false

enum GAME_STATE {
	PLAYING,
	LEVEL_COMPLETED,
	GAME_OVER
}

enum POWERUP {
	NONE, 
	JUMP, 
	BREAK, 
	SPEED, 
	THUNDER
}

const LEVEL_MAP : Dictionary = {
	"LAZER MAZE" : "res://scenes/levels/LazerMaze/lazer.tscn",
	"BOUNCE" : "res://scenes/levels/Bounce/bounce.tscn",
	"CHASE" : "res://scenes/levels/Chase/chase.tscn",
	"ROLLERCOASTER" : "res://scenes/levels/Rollercoaster/rollercoaster.tscn",
	"LOOPS" : "res://scenes/levels/Loops/loops.tscn",
	"CITY" : "res://scenes/levels/City/city.tscn",
	"DISCO" : "res://scenes/levels/Disco/disco.tscn",
	"CASTLE" : "res://scenes/levels/Castle/castle.tscn",
	"CANNON" : "res://scenes/levels/Cannon/cannon.tscn",
	"JUMP" : "res://scenes/levels/Jump/jump.tscn",
	"KILLER" : "res://scenes/levels/Killer/killer.tscn",
	"TRAPPED" : "res://scenes/levels/Trapped/trapped.tscn",
	"CASTLECOASTER" : "res://scenes/levels/Castlecoaster/castlecoaster.tscn",
	"NIGHTMARE" : "res://scenes/levels/Nightmare/nightmare.tscn"
}


const CAMPAIGN = [
#	"CHASE"
	"LAZER MAZE",
	"CHASE",
	"BOUNCE",
	"DISCO",
	"LOOPS",
	"ROLLERCOASTER",
	"CITY",
	"CASTLE",
	"CANNON",
	"JUMP",
	"KILLER",
	"TRAPPED",
	"CASTLECOASTER",
	"NIGHTMARE"
]


const scorePath : String = "user://scores.igsb"
const scorePass : String = "SebastianAaltonen"

func get_highscores()->Dictionary:
	
	if !FileAccess.file_exists(scorePath):
		return {}
		
	var file = FileAccess.open_encrypted_with_pass(scorePath, FileAccess.READ, scorePass)
	
	var json_object = JSON.new()
	
	if json_object.parse(file.get_as_text()):
		return {}
	
	var highscores : Dictionary = json_object.get_data()
	
	return highscores

func normalize_axis(axis : float) :
	
	if axis == 0: return axis
	
	if axis < 0: return -1
	
	return 1
