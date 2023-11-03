extends StaticBody3D

func _ready():
	pass

func _process(delta):
	pass

enum POWERUP {NONE, JUMP, BREAK, SPEED, LIGHTNING}

var m_powerup := POWERUP.NONE

var color := Color("WHITE")

func set_powerup(powerup):
	
	m_powerup = powerup
	
	match(powerup):
		POWERUP.JUMP:
			color = Color("YELLOW", 0.6)
		POWERUP.BREAK:
			color = Color("GREEN", 0.6)
		POWERUP.SPEED:
			color = Color("RED", 0.6)
		POWERUP.LIGHTNING:
			color = Color("BLUE", 0.6)

	$Node3D/MeshInstance3D.mesh.material.albedo_color = color
	
func player_passed_through(player):
		
	player.setPowerup(m_powerup)


func _on_body_entered(body):
	if body.name == "Player":
		body.set_powerup(m_powerup)
