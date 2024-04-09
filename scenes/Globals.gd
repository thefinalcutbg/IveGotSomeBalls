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
	"CHASE" : "res://scenes/levels/Chase/chase.tscn",
	"LOOPS" : "res://scenes/levels/Loops/loops.tscn",
}


const CAMPAIGN = [
	"LAZER MAZE",
	"CHASE",
	"LOOPS"
]

const SINGLE_LEVEL = [
	"LAZER MAZE",
	"CHASE",
	"LOOPS"
]

