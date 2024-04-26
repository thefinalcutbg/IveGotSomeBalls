extends RigidBody3D

#some constants
const _break_coef = 0.08
const _speed_coef = 2.5
const _speed_boost = 1.2 #initial boost when speed powerup is applied
var jump_coef = [30,35,45,65] #for each successive jump
var _is_colliding = false

@onready var particles = $GPUParticles3D

var m_powerup := Globals.POWERUP.NONE


var _powerup_sounds = [
	0, 
	load("res://assets/audio/byellow.wav"),
	load("res://assets/audio/bgreen.wav"),
	load("res://assets/audio/bred.wav"),
	load("res://assets/audio/bblue.wav")
	]

var collision := false

func _ready():
	pass

func _physics_process(delta):
	
	var input := Vector3.ZERO
	input.x = Input.get_axis("ui_left", "ui_right")
	input.z = Input.get_axis("ui_up", "ui_down")

	var force = $CameraPivot.basis * input * 30

	_rotate_camera()
	
	if m_powerup == Globals.POWERUP.SPEED: force*=_speed_coef
	
	apply_central_force(force)
	
	processJump()
	
	processBreak()


func set_powerup(pw):
	
	if m_powerup == pw: return
	
	m_powerup = pw
	
	$PowerUpPlayer.stream = _powerup_sounds[pw]
	
	var color
		
	match m_powerup:
		Globals.POWERUP.JUMP: 
			color = Color("YELLOW", 1)
			jump_guard = false
			contact_monitor = true
		Globals.POWERUP.BREAK:
			color = Color("GREEN", 0.8)
		Globals.POWERUP.SPEED:
			color = Color("RED", 0.8)
		Globals.POWERUP.THUNDER:
			color = Color("BLUE", 0.3)
		Globals.POWERUP.NONE:
			color = Color("WHITE", 1)
	
	if m_powerup != Globals.POWERUP.NONE:
		$PowerUpPlayer.play()
	
	$MeshInstance3D.mesh.material.albedo_color = color
	particles.draw_pass_1.material.albedo_color = color
	particles.draw_pass_1.material.emission = color
	
	if m_powerup == Globals.POWERUP.SPEED:
			apply_central_impulse(linear_velocity*_speed_boost)
			particles.emitting = true
			gravity_scale = 2
	else:
		particles.emitting = false
		gravity_scale = 1
	
	$Thunder.visible = m_powerup == Globals.POWERUP.THUNDER
	


func set_thunder_range(radius):
	$ThunderRange/CollisionShape3D.shape.radius = radius

func respawn():
	
	contact_monitor = false
	jump_guard = false
	_is_colliding = false
	linear_velocity = Vector3.ZERO
	global_position = Vector3(0,3,0)
	$CameraPivot.rotation = Vector3.ZERO
	physics_material_override.bounce = 0.6
	gravity_scale = 1
	jump_coef = [30,35,45]
	set_thunder_range(20)
	m_powerup = Globals.POWERUP.NONE
	$MeshInstance3D.mesh.material.albedo_color = Color("WHITE", 1)
	$Thunder.visible = false
	particles.emitting = false

func _rotate_camera():
	
	var movement_vec2d = Vector2(linear_velocity.x, linear_velocity.z)
	var cam_vec = $CameraPivot.global_position - $CameraPivot/Camera3D.global_position
	var camera_vec2d = Vector2(cam_vec.x, cam_vec.z)
	var twist_input = rad_to_deg(movement_vec2d.angle_to(camera_vec2d))
	
	if twist_input < -90 :	
		twist_input = -180-twist_input
	elif twist_input > 90 :
		twist_input = 180-twist_input
		
	$CameraPivot.rotate_y(twist_input*0.00003*movement_vec2d.length())


var jump_index := 0
var jump_guard = false

func processJump():
	
	if m_powerup != Globals.POWERUP.JUMP: return
	
	if !_is_colliding:
		jump_guard = false
		return
	
	if !Input.is_key_pressed(KEY_SPACE):
		jump_index = max(jump_index-1, 0)
		return
	
	if jump_guard: return
	
	jump_guard = true #prevents switching through jump indexes at once
	
	$JumpParticleTimer.start()
	particles.emitting = true
	
	if !$RayCast3D.is_colliding(): return
	
	linear_velocity.y = jump_coef[jump_index]

	jump_index = min(jump_index+1, jump_coef.size()-1)

	
func processBreak():
	
	if m_powerup != Globals.POWERUP.BREAK: return
	
	if !Input.is_key_pressed(KEY_SPACE): 
		particles.emitting = false
		return
	
	particles.emitting = true
	
	apply_central_impulse(-linear_velocity*_break_coef)


func _on_jump_particle_timer_timeout():
	particles.emitting = false

func _on_body_entered(body):
	_is_colliding = true

func _on_body_exited(body):
	_is_colliding = false
