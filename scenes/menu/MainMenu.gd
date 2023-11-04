extends Node3D

const SUBMENU = preload("res://scenes/menu/SubMenu.tscn")

@onready var sphere = $Sphere
@onready var viewport = $SubViewport
@onready var menu_labels = $SubViewport/MenuLabels

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
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

	
func start_game():
	get_parent().start_game()
	
func open_submenu():
	
		var subMenu = SUBMENU.instantiate()
		subMenu.set_main_menu(self)
		$SubMenuScreen/SubMenuViewport.add_child(subMenu)
		subMenu.add_label("L1", "HAHAHA")
		subMenu.add_label("L2", "HAHAHA")
		#if $AnimationPlayer.is_playing(): return
		$AnimationPlayer.play_backwards("ComeOut")
		menu_labels.is_current = false
		$SubMenuScreen.visible = true

func close_submenu():
		$SubMenuScreen/SubMenuViewport.get_child(0).queue_free()
		#if $AnimationPlayer.is_playing(): return
		$AnimationPlayer.play("ComeOut")
		menu_labels.is_current = true

func quit():
	get_tree().quit()
	
func set_option(index):
	print(index)
