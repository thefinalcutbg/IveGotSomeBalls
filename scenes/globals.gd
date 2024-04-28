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
	"TRAPPED"
]

const SINGLE_LEVEL = [
	"BOUNCE",
	"CANNON",
	"CASTLE",
	"CHASE",
	"CITY",
	"DISCO",
	"JUMP",
	"KILLER",
	"LAZER MAZE",
	"LOOPS",
	"ROLLERCOASTER",
	"TRAPPED"
]

