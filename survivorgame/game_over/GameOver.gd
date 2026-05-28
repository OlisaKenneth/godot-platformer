extends Control

func _on_retry_button_pressed() -> void:
	visible = false
	get_tree().change_scene_to_file("res://main.tscn")


func _on_main_menu_button_pressed() -> void:
	visible = false
	var main_menu_scene: PackedScene = preload("res://main_menu/main_menu.tscn")
	get_tree().change_scene_to_packed(main_menu_scene)
