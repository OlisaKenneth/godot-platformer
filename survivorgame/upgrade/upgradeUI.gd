extends Control

@onready var button_1: Button = $Button
@onready var button_2: Button = $Button2

func get_buttons() -> Array:
	return [button_1, button_2]
