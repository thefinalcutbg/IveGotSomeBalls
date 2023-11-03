extends Node3D

var body
var diamond

func set_connectors(player, diamond):
	self.body = player
	self.diamond = diamond

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.

var reverse = 0

func _process(delta):
	
	if !body or !diamond: 
		queue_free()
		return
	
	$CSGPolygon3D.path_u_distance += 0.01
	$Path3D.curve.set_point_position(1, diamond.global_position)
	$Path3D.curve.set_point_position(0, body.global_position)
