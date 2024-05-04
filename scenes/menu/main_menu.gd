extends Node3D

@onready var MAINMENU = $SubViewport/MainMenuLabels
@onready var SUBMENU =  $SubMenuScreen/SubMenuViewport/SubMenu

enum MENU_SECTION {NONE, SINGLE, HIGHSCORE, SETTINGS}

var _section : MENU_SECTION = MENU_SECTION.NONE

func setViewport(object, vp):
	var material = object.get_active_material(0)
	material.set_texture(0, vp.get_texture())
	object.set_surface_override_material(0, material)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#setting viewport to the sphere programatically becasue of bug in the editor
	setViewport($Sphere, $SubViewport)
	setViewport($SubMenuScreen, $SubMenuScreen/SubMenuViewport)
	
	SUBMENU.disable_input = true
	MAINMENU.disable_input = true
	
	$AnimationPlayer.play("ComeOut")
	
	pass

func _on_animation_player_animation_finished(anim_name):

	match anim_name:
		"GoIn": 
			SUBMENU.disable_input = false
		"ComeOut":
			SUBMENU.clear()
			MAINMENU.disable_input = false
			

func _on_main_menu_labels_option_selected(label_name):
	
	match(label_name):
		"Start": 
			get_tree().get_current_scene().start_game()
			return
		"SingleMap":
			var unlocked = Globals.LEVEL_MAP.keys()
			unlocked.sort()
			#var unlocked = Globals.get_highscores().keys()
			if unlocked.is_empty():
				SUBMENU.add_label("Play more to unlock this section")
			
			for level_name in unlocked:
				SUBMENU.add_label(level_name)
				
			_section = MENU_SECTION.SINGLE
		"Scores":
			var scores = Globals.get_highscores()
			
			if scores.is_empty():
				SUBMENU.add_label("No scores found")
				
			for key in scores:
				var text = key + " " 
				text += str(scores[key][0]).pad_decimals(2)
				text += " [" + scores[key][1] + "]"
				SUBMENU.add_label(text)
				
		"Quit": get_tree().quit()
	
	MAINMENU.disable_input = true

	SUBMENU.visible = true
	$AnimationPlayer.play("GoIn")


func _on_sub_menu_menu_canceled():
	
	SUBMENU.disable_input = true
	$AnimationPlayer.play("ComeOut")


func _on_sub_menu_option_selected(index):
	
	match _section:
		MENU_SECTION.NONE:
			return
		MENU_SECTION.SINGLE:
			var level_name = SUBMENU.get_label_text(index)
			get_tree().get_current_scene().play_level(level_name)
