extends Area3D

var _player = null
var _vector = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	
	if _player == null: return

	_player.apply_central_force(_vector*delta*100000)

func set_vector(vector):
	_vector = vector

func _on_body_entered(body):
	
	if body.name != "Player": return
	
	_player = body


func _on_body_exited(body):
	
	if body.name != "Player": return
	
	_player = null

