extends Node3D

func _ready():
	$Gate.set_powerup(Globals.POWERUP.JUMP)
	$AccelerationArea.set_vector(Vector3(0,0,1))
	$AnimationPlayer.play("BarrierAnimation")

func _physics_process(delta):
	$Diamonds/Path3D/PathFollow3D.progress += 90.0*delta
	
