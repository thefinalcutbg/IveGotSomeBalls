extends Node3D

@onready var sphere = $Sphere
@onready var viewport = $SubViewport

var camera_inside = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$MfBallsAudio.play()
	#setting viewport to the sphere programatically becasue of bug in the editor

	var material = $Sphere.get_active_material(0)
	
	#aterial.set_albedo(Color(215,215,215))
	material.set_texture(0, viewport.get_texture())
	
	sphere.set_surface_override_material(0, material)
	
	$AnimationPlayer.play("ComeOut")
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if $AnimationPlayer.is_playing(): return
	
	if Input.is_key_pressed(KEY_SPACE):
		get_parent().playGame()
		if camera_inside: return
		
		$AnimationPlayer.play_backwards("ComeOut")
		camera_inside = !camera_inside
	
	if Input.is_key_pressed(KEY_ESCAPE):
		if !camera_inside: return
		
		$AnimationPlayer.play("ComeOut")
		camera_inside = !camera_inside
	
	pass
