extends StaticBody3D

func _ready():
	pass

func _process(delta):
	pass

var m_powerup := Globals.POWERUP.NONE

var color := Color("WHITE")

func set_powerup(powerup):
	
	m_powerup = powerup
	
	match(powerup):
		Globals.POWERUP.JUMP:
			color = Color("YELLOW", 0.6)
		Globals.POWERUP.BREAK:
			color = Color("GREEN", 0.6)
		Globals.POWERUP.SPEED:
			color = Color("RED", 0.6)
		Globals.POWERUP.THUNDER:
			color = Color("BLUE", 0.6)

	$Node3D/MeshInstance3D.mesh.material.albedo_color = color
	
func player_passed_through(player):
		
	player.setPowerup(m_powerup)


func _on_body_entered(body):
	if body.name == "Player":
		body.set_powerup(m_powerup)
