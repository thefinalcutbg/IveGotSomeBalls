extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Control/Label.visible = false
	pass # Replace with function body.

func set_time(time : float):
	
	var hours = int(time)/3600
	time -= hours * 3600
	
	var minutes = int(time) / 60
	time -= minutes * 60
	
	var seconds = int(time) 
	
	var milliseconds = int((time - int(time)) * 100)
	
	var time_string = "%02d:%02d:%02d:%02d" % [hours, minutes, seconds, milliseconds]
	$Control/Label.text = "TOTAL TIME: " + time_string + "\n "

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		get_parent().return_to_main_menu()


func _on_animation_player_animation_finished(anim_name):
	$Control/Label.visible = true
