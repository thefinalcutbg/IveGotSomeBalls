extends Node3D

@onready var pistonM1 = $castle/cyl_dyn_m1
@onready var pistonM2 = $castle/cyl_dyn_m2
@onready var pistonS1 = $castle/cyl_dyn_s1
@onready var pistonS2 = $castle/cyl_dyn_s2

func set_player_parameters(player):
	pass

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	print(pistonM1.position.z)
	print(pistonM2.position.z)
	pass
