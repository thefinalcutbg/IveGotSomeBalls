extends Node3D

@onready var barriers = $Barriers
# Called when the node enters the scene tree for the first time.
func _ready():
	$trapped/light.cast_shadow = false
#	$trapped/light_001.cast_shadow = false
	$trapped/AnimationPlayer.play("CubeAction")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$trapped/light.rotate_y(+0.005)
	

func set_player_parameters(player):
	pass

