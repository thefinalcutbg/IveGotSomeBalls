extends Node3D

var _body
var _diamond

func set_connectors(player, diamond):
	_body = player
	_diamond = diamond

var reverse = 0

func _physics_process(delta):
	
	#automatic self-destruction
	if !_body or !_diamond: 
		queue_free()
		return
	
	$CSGPolygon3D.path_u_distance += 0.01
	$Path3D.curve.set_point_position(1, _diamond.global_position)
	$Path3D.curve.set_point_position(0, _body.global_position)
