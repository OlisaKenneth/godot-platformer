extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_options_pressed() -> void:
	# Instead of trying to get filename, manually store this scene path
	GameState.set_previous_scene("res://main_menu/main_menu.tscn") # replace if your scene path differs

	# Open options scene
	get_tree().change_scene_to_file("res://options.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_button_pressed() -> void:
	GameState.start_game()  # mark game as started
	get_tree().change_scene_to_file("res://main.tscn")
