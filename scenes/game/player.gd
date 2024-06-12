extends RigidBody3D

#some constants
const _break_coef = 0.004

var jump_coef = [3,3.5,4.5,6.5] #for each successive jump
var body_collisions : Array #stores the bodies the player is colling with

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

const _speed_coef = 2.5

func _physics_process(delta):
	
	var input := Vector3.ZERO
	input.x = Globals.normalize_axis(Input.get_axis("ui_left", "ui_right"))
	input.z = Globals.normalize_axis(Input.get_axis("ui_up", "ui_down"))


	var force = $CameraPivot.basis * input

	var coef = 0.28
	
	var angle = rad_to_deg(force.angle_to(linear_velocity))
	#modify coef here according to angle:
	#if angle > 90: coef += angle*0.003
	
	force *= coef
	
	_rotate_camera()
	
	if m_powerup == Globals.POWERUP.SPEED: force*=_speed_coef
	
	#grounding on slopes
	if body_collisions.size() and $RayCast3D.is_colliding():
		force.y = -0.5

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
			color = Color("YELLOW")
			jump_guard = false
			#sometimes collision doesn't work
		Globals.POWERUP.BREAK:
			color = Color("GREEN", 0.8)
		Globals.POWERUP.SPEED:
			color = Color("RED", 0.8)
		Globals.POWERUP.THUNDER:
			color = Color("BLUE")
		Globals.POWERUP.NONE:
			color = Color("WHITE")
	
	if m_powerup != Globals.POWERUP.NONE:
		$PowerUpPlayer.play()
	
	$MeshInstance3D.mesh.material.albedo_color = color
	color.a = 1
	particles.draw_pass_1.material.albedo_color = color
	
	if m_powerup == Globals.POWERUP.SPEED:
			particles.emitting = true
			gravity_scale = 2
	else:
		particles.emitting = false
		gravity_scale = 1
	
	$Thunder.visible = m_powerup == Globals.POWERUP.THUNDER
	


func set_thunder_range(radius):
	$ThunderRange/CollisionShape3D.shape.radius = radius

func respawn():
	#resetting all parameters to default
	jump_guard = false
	linear_velocity = Vector3.ZERO
	global_position = Vector3(0,0.3,0)
	$CameraPivot.rotation = Vector3.ZERO
	physics_material_override.bounce = 0.6
	gravity_scale = 1
	jump_coef = [3,3.5,4.5]
	jump_index = 0
	set_thunder_range(1.5)
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
		
	$CameraPivot.rotate_y(twist_input*0.00015*movement_vec2d.length())


var jump_index := 0
var jump_guard = false

func processJump():
	
	if m_powerup != Globals.POWERUP.JUMP: return
	
	if body_collisions.is_empty():
		jump_guard = false
		return
	
	if !Input.is_action_pressed("ui_select"):
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
	
	if !Input.is_action_pressed("ui_select"):
		particles.emitting = false
		return
	
	particles.emitting = true
	
	apply_central_impulse(-linear_velocity*_break_coef)

func _on_jump_particle_timer_timeout():
	particles.emitting = false


func _on_body_entered(body):
	body_collisions.push_back(body)

func _on_body_exited(body):
	
	for i in body_collisions.size():
		if body_collisions[i] == body:
			body_collisions.pop_at(i)
			break
	
	if body_collisions.is_empty():
		jump_guard = false
