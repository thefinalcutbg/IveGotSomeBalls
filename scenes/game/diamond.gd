extends Area3D

var _game
var collected = false

func set_game(game):
	_game = game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	$Outer.rotate_y(deg_to_rad(1))

	if !collected: return
	
	$Inner.scale = lerp($Inner.scale, Vector3.ZERO, 0.05)
	$Outer.scale = lerp($Outer.scale, Vector3.ZERO, 0.05)
	
	if $Outer.scale < Vector3(0.01,0.01,0.01):
		queue_free()


func _on_area_entered(area):

	if collected: return
	
	if area.name != "ThunderRange": return
	
	if area.get_parent().m_powerup != 4: return
	
	_game.spawn_thunder(area.get_parent(), self)
	
	_game.diamond_collected(false)
	
	collected = true


func _on_body_entered(body):
	
	if collected: return
	
	if body.name != "Player": return
	
	_game.diamond_collected(true)
	
	collected = true

