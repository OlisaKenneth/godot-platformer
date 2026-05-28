extends Node

class_name Gamestate

var started: bool = false
var previous_scene: String = ""  # store the scene that opened options (if any)
var enemies_killed := 0 # track how many enemies have been killed to determine when boss should spawn
var boss_spawned := false

func start_game() -> void:
	started = true

func reset_game() -> void:
	started = false

func set_previous_scene(path: String) -> void:
	previous_scene = path
