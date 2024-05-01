extends Area3D

var _player = null
var _vector
var coef
var _player_old_bounce

func _ready():
	coef = 1300
	_vector = Vector3.ZERO

func _physics_process(delta):
	
	if _player == null: return

	_player.apply_central_force(_vector*delta*coef)

func set_vector(vector):
	_vector = vector

func _on_body_entered(body):
	
	if body.name != "Player": return
	
	_player = body
	_player_old_bounce = _player.physics_material_override.bounce
	_player.physics_material_override.bounce = 0.1

func _on_body_exited(body):
	
	if body.name != "Player": return
	
	_player.physics_material_override.bounce = _player_old_bounce
	
	_player = null

