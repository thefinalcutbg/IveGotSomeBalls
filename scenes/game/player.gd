extends RigidBody3D

#these nodes are children of the player
@onready var mesh = $MeshInstance3D
@onready var rayCast = $RayCast3D
@onready var twist_pivot = $Camera
@onready var camera = $Camera/Camera3D
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

func _process(delta):

	var input := Vector3.ZERO
	input.x = Input.get_axis("ui_left", "ui_right")
	input.z = Input.get_axis("ui_up", "ui_down")

	var force = twist_pivot.basis * input * 22000 * delta
	
	rotate_camera()
	
	if m_powerup == Globals.POWERUP.SPEED: force*=3.0
	
	#apply_central_impulse(force)
	apply_central_force(force)
		
	processJump()
	
	processBreak()



func set_camera(cameraNode):
	return
	twist_pivot = cameraNode
	camera = cameraNode.get_node("Camera3D")

func set_powerup(pw):
	
	if m_powerup == pw: return
	
	m_powerup = pw
	
	$PowerUpPlayer.stream = _powerup_sounds[pw]
	
	var color
		
	match m_powerup:
		Globals.POWERUP.JUMP: 
			color = Color("YELLOW", 1)
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
			apply_central_impulse(linear_velocity*12)
			particles.emitting = true
			gravity_scale = 2
	else:
		particles.emitting = false
		gravity_scale = 1


func respawn():
	$SpawnAudio.play()
	$MeshInstance3D.mesh.material.albedo_color = Color("WHITE", 1)
	m_powerup = Globals.POWERUP.NONE
	linear_velocity = Vector3.ZERO
	global_position = Vector3(0,1,0)
	twist_pivot.rotation = Vector3.ZERO


func rotate_camera():
	
	var movement_vec2d = Vector2(linear_velocity.x, linear_velocity.z)
	var cam_vec = twist_pivot.global_position - camera.global_position
	var camera_vec2d = Vector2(cam_vec.x, cam_vec.z)
	var twist_input = rad_to_deg(movement_vec2d.angle_to(camera_vec2d))
	
	if twist_input < -90 :	
		twist_input = -180-twist_input
	elif twist_input > 90 :
		twist_input = 180-twist_input
		
	twist_pivot.rotate_y(twist_input*0.00003*movement_vec2d.length())


#var rotation_x = 0.0
#var rotation_z = 0.0
#
#func rotate_mesh():
#
#	var vec = linear_velocity.normalized()
#	var speed = linear_velocity.length()
#
#	if !speed : return
#
#	if !collision: 
#		rotation_x = lerp(rotation_x, 0.0, 0.01)
#		rotation_z = lerp(rotation_z, 0.0, 0.01)
#	else:
#		rotation_x = vec.z*0.0314*speed
#		rotation_z = -vec.x*0.0314*speed
#
#	mesh.rotate_x(rotation_x)
#	mesh.rotate_z(rotation_z)


#static variables:
var jump_index := 0
#in case of longer collisions:
var on_ground_jumping := false

const jump_velocity = [40,50,60]


func processJump():
	
	if m_powerup != Globals.POWERUP.JUMP: return
	
	var spacePressed = Input.is_key_pressed(KEY_SPACE)
	
	if !spacePressed:
		particles.emitting = false
	
	jump_index = clamp(jump_index, 0, jump_velocity.size()-1)
	
	if !collision:
		on_ground_jumping = false
		return
	elif spacePressed:
		particles.emitting = true
	
	if !spacePressed:
		jump_index -= 1
		return
	
	#enable animation here
	
	if on_ground_jumping: return
	
	if !$RayCast3D.is_colliding():
		#handle bounce of body
		return

	on_ground_jumping = true
	
	linear_velocity.y = jump_velocity[jump_index]
	
	jump_index += 1

func playPickupSound():
	pass
	#$PickupSound.play()
	
func processBreak():
	
	if m_powerup != Globals.POWERUP.BREAK: return
	
	if !Input.is_key_pressed(KEY_SPACE): 
		particles.emitting = false
		return
	
	particles.emitting = true
	
	apply_central_impulse(-linear_velocity*0.7)



func _on_body_entered(body):
	collision = true
	processJump()


func _on_body_exited(body):
	collision = false
