extends Node3D

const SUBMENU = preload("res://scenes/menu/SubMenu.tscn")

@onready var sphere = $Sphere
@onready var viewport = $SubViewport
@onready var menu_labels = $SubViewport/MenuLabels


var single_levels = {
	"Chase": "res://scenes/game/levels/Chase.tscn",
	"Loops": "res://scenes/game/levels/Loops.tscn",
	"LazerMaze": "res://scenes/game/levels/LazerMaze.tscn"
}

func setViewport(object, vp):
	var material = object.get_active_material(0)
	material.set_texture(0, vp.get_texture())
	object.set_surface_override_material(0, material)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$MfBallsAudio.play()
	
	#setting viewport to the sphere programatically becasue of bug in the editor
	setViewport($Sphere, $SubViewport)
	setViewport($SubMenuScreen, $SubMenuScreen/SubMenuViewport)
	
	$SubMenuScreen.visible = false
	
	$AnimationPlayer.play("ComeOut")
	
	menu_labels.disable_input = true
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

	
func start_game():
	get_parent().start_game()
	
func open_submenu(type):
		
		menu_labels.disable_input = true
		
		var subMenu = SUBMENU.instantiate()
		subMenu.set_param(self, type)
		$SubMenuScreen/SubMenuViewport.add_child(subMenu)
		subMenu.set_process(false)
		
		match type:
			Globals.MENU_TYPE.SETUP:
				subMenu.add_label("SOUND VOLUME: " + db_to_percent(1))
				subMenu.add_label("MUSIC VOLUME: " + db_to_percent(2))
				subMenu.scroll = false
			Globals.MENU_TYPE.SINGLE_LEVEL:
				for key in single_levels:
					subMenu.add_label(key)
			_:
				for key in single_levels:
					subMenu.add_label(key)

		
		#match the type of the submenu

		$AnimationPlayer.play("GoIn")
		$SubMenuScreen.visible = true
		

func close_menu_requested():
		
	$SubMenuScreen/SubMenuViewport.get_child(0).set_process(false)
	$AnimationPlayer.play("ComeOut")


func quit():
	get_tree().quit()
	


func _on_animation_player_animation_finished(anim_name):

	match anim_name:
		"GoIn": 
			current_submenu().set_process(true)
		"ComeOut":
			var submenu = current_submenu()
			if submenu: submenu.queue_free()
			menu_labels.disable_input = false
			


func option_selected(index):
	
	var submenu = current_submenu()
	
	match submenu.type:
		Globals.MENU_TYPE.SETUP:
			if !index:
				set_volume(index+1) 
				submenu.set_label_text(index, "SOUND VOLUME: " + db_to_percent(index+1))
			else:
				set_volume(index+1) 
				submenu.set_label_text(index, "MUSIC VOLUME: " + db_to_percent(index+1))
		Globals.MENU_TYPE.SINGLE_LEVEL:
			get_parent().play_level(single_levels[submenu.get_current_text()])
			
func current_submenu():
	return $SubMenuScreen/SubMenuViewport.get_child(0)
			
		
func db_to_percent(bus_index):
	
	var dictionary = {
		-80.0: "0%",
		-20.0: "25%",
		-10.0: "50%",
		-5.0: "75%",
		0.0: "100%"
	}
	
	return dictionary[AudioServer.get_bus_volume_db(bus_index)]

func set_volume(idx):
	
	var increment = {
		0.0:	-80.0,
		-80.0:	-20.0,
		-20.0:	-10.0,
		-10.0:	-5.0,
		-5.0:	0.0
	}
	
	AudioServer.set_bus_volume_db(
		idx, 
		increment[
			AudioServer.get_bus_volume_db(idx)
			]
		)
