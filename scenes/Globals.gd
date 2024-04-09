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
	"CHASE" : "res://scenes/levels/Chase/chase.tscn",
	"LOOPS" : "res://scenes/levels/Loops/loops.tscn"
}


const CAMPAIGN = [
	"TEST LEVEL",
	"LAZER MAZE",
	"CHASE",
	"LOOPS"
]

const SINGLE_LEVEL = [
	"LAZER MAZE",
	"CHASE",
	"LOOPS"
]

