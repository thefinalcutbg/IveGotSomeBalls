extends Node

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

func get_highscores()->Dictionary:
	
	if !FileAccess.file_exists("user://scores.json"):
		return {}
		
	var file = FileAccess.open("user://scores.json", FileAccess.READ)
	
	var json_object = JSON.new()
	
	if json_object.parse(file.get_as_text()):
		return {}
	
	var highscores : Dictionary = json_object.get_data()
	
	return highscores
