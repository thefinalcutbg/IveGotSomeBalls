extends Area3D

var m_game
var collected = false

func set_game(game):
	m_game = game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	$Outer.rotate_y(deg_to_rad(2))

	if !collected: return
	
	$Inner.scale = lerp($Inner.scale, Vector3.ZERO, 0.1)
	$Outer.scale = lerp($Outer.scale, Vector3.ZERO, 0.1)
	
	if $Outer.scale < Vector3(0.05,0.05,0.05):
		queue_free()


func collect():
	m_game.diamond_collected()
	collected = true

func _on_area_entered(area):

	if collected: return
	
	if area.name != "ThunderRange": return
	
	if area.get_parent().m_powerup != 4: return
	
	m_game.spawn_thunder(area.get_parent(), self)
	
	collect()


func _on_body_entered(body):
	
	if collected: return
	
	if body.name != "Player": return
	
	$DiamondSound.play()
	
	collect()

