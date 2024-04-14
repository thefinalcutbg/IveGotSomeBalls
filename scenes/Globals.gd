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
	"TEST LEVEL" : "res://scenes/levels/TestLevel.tscn",
	"LAZER MAZE" : "res://scenes/levels/LazerMaze/lazer.tscn",
	"BOUNCE" : "res://scenes/levels/Bounce/bounce.tscn",
	"CHASE" : "res://scenes/levels/Chase/chase.tscn",
	"LOOPS" : "res://scenes/levels/Loops/loops.tscn",
	
}


const CAMPAIGN = [
	"LAZER MAZE",
	"CHASE",
	"BOUNCE",
	"LOOPS"
]

const SINGLE_LEVEL = [
	"TEST LEVEL",
	"BOUNCE",
	"LAZER MAZE",
	"CHASE",
	"LOOPS"
]

