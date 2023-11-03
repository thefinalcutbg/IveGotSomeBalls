extends Node3D

const testLevel = preload("res://scenes/game/levels/testLevel.tscn")

var current_level

var diamondCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.set_camera($Camera)
	
	load_level()

	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.

func load_level():
	if current_level: current_level.queue_free()
	
	current_level = testLevel.instantiate()
	add_child(current_level)
	var diamondNode = current_level.find_child("Diamonds")
	diamondCount = diamondNode.get_child_count()
	
	for d in diamondNode.get_children():
		d.set_game(self)
	
	$Player.respawn()

func diamond_collected():
	diamondCount -= 1
	print(diamondCount)
	
	if !diamondCount: load_level()

func _process(delta):
	pass


func spawn_thunder(player, diamond):
	
	const THUNDER_SCENE = preload("res://scenes/game/objects/thunder_bolt.tscn")
	
	var thunder = THUNDER_SCENE.instantiate()
	thunder.set_connectors(player, diamond)
	add_child(thunder)
	$ThunderSound.play()
	
func _on_death_area_area_entered(area):
	load_level()
