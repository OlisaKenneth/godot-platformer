extends Node

class_name AudioManager

var master_volume_db: float = 0.0
var music_volume_db: float = 0.0
var sfx_volume_db: float = 0.0

func _ready():
	update_volumes()

func update_volumes():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), master_volume_db)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), music_volume_db)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), sfx_volume_db)

func set_music_volume(value: float):
	music_volume_db = linear_to_db(value)
	update_volumes()

func set_sfx_volume(value: float):
	sfx_volume_db = linear_to_db(value)
	update_volumes()
