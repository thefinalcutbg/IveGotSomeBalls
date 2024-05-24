extends Node

const settingsPath : String = "user://settings.json"

enum SET { RES = 0, MODE = 1, SYNC = 2, FX = 3, MUSIC = 4, SPEEDRUN = 5}

var _settings : Array = [8,0,0,4,4,0]

const _constants = [
	[
		Vector2i(1024,768),
		Vector2i(1280,720),
		Vector2i(1280,800),
		Vector2i(1280,1024),
		Vector2i(1366,768),
		Vector2i(1440,900),
		Vector2i(1600,900),
		Vector2i(1680,1050),
		Vector2i(1920,1080),
		Vector2i(2560,1440),
		Vector2i(3840,2160)
	],
	[
	 DisplayServer.WINDOW_MODE_FULLSCREEN,
	 DisplayServer.WINDOW_MODE_MAXIMIZED
	],
	[
	 DisplayServer.VSYNC_DISABLED,
	 DisplayServer.VSYNC_ENABLED,
	 DisplayServer.VSYNC_ADAPTIVE
	],
	[-80.0, -20.0, -10.0, -5.0, 0 ],
	[-80.0, -20.0, -10.0, -5.0, 0 ],
	[0,1]
]

const _text = [
	[
		"1024x768",
		"128x720",
		"1280x800",
		"1280x1024",
		"1366x768",
		"1440x900",
		"1600x900",
		"1680x1050",
		"1920x1080",
		"2560x1440",
		"3840x2160"
	],
	["FULLSCREEN","WINDOWED"],
	["DISABLED", "ENABLED", "ADAPTIVE"],
	["0%", "25%", "50%", "75%", "100%"],
	["0%", "25%", "50%", "75%", "100%"],
	["HIDE", "SHOW"]
	
]

func _next_option(current_idx:int, max_idx:int)->int:
	
	current_idx += 1
	
	if current_idx == max_idx:
		current_idx = 0
	
	return current_idx

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if FileAccess.file_exists(settingsPath): 
		
		var file = FileAccess.open(settingsPath, FileAccess.READ)
	
		var json_object = JSON.new()
	
		if !json_object.parse(file.get_as_text()):
			_settings  = json_object.get_data()
	
	for i in _settings.size():
		_set_value(i, _settings[i])
	

func settings_changed(index : int):
	
	var value = _next_option(_settings[index], _constants[index].size())
	
	_set_value(index, value)

func _set_value(option : SET, value : int) :
	
	_settings[option] = value
	
	match(option):
		SET.RES:
			get_viewport().content_scale_size = _constants[SET.RES][value]
		SET.MODE:
			DisplayServer.window_set_mode(_constants[SET.MODE][value])
		SET.SYNC:
			DisplayServer.window_set_vsync_mode(value)
		SET.FX:
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"), _constants[SET.FX][value])
		SET.MUSIC:
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), _constants[SET.FX][value])
		SET.SPEEDRUN:
			Globals.show_speedrun = _constants[SET.SPEEDRUN][value]
			
	var file = FileAccess.open(settingsPath, FileAccess.WRITE)
	
	file.store_string(JSON.stringify(_settings))

func get_label_text(index : int)->String:
	
	const descr = ["Resolution: ", "Window Mode: ", "VSync: ", "Sound: ", "Music: ", "Speedrun Timer: " ]
	
	return descr[index] + _text[index][_settings[index]]

func options_count()->int:
	return _settings.size()
