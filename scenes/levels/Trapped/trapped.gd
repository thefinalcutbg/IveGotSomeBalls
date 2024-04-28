extends Node3D

@onready var barriers = $Barriers
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$trapped/light.rotate_y(+0.01)

func set_player_parameters(player):
	pass

