extends Node

class_name Upgrade

## An object used to model upgrades
##
## Contains functionality to [method Upgrade.add_xp], [method Upgrade.level_up], [method Upgrade.pick_random_upgrades]
## [method Upgrade.apply_max_health_upgrade], [method Upgrade.apply_bullet_speed_upgrade], 
## [method Upgrade.apply_damage_upgrade], [method Upgrade.apply_speed_upgrade]

## Current upgrade UI
var upgrade_ui: Control = null

## Current XP
var xp: int = 0
## XP required for level up
var xp_for_level_up: int = 3
## Current level
var level: int = 1
## Exponent used for XP required to level up
var exponent: int = 1

## Available upgrades
var upgrades: Array = [
		{"name": "Max Health", "description": "Increase maximum health", "function_name": "apply_max_health_upgrade"},
		{"name": "Bullet Speed", "description": "Increase bullet speed", "function_name":  "apply_bullet_speed_upgrade"},
		{"name": "Damage", "description": "Increase damage", "function_name": "apply_damage_upgrade"},
		{"name": "Movement Speed", "description": "Increase movement speed", "function_name": "apply_speed_upgrade"},
	]

## Increases [member xp] by 1 and checks if [member xp] is enough to level up.
func add_xp() -> void:
	xp += 1
	if xp == xp_for_level_up:
		level_up()

## Increases the [member level] by 1, resets [member xp] to 0 and calculates the required XP for next level up.
func level_up() -> void:
	level += 1
	xp = 0
	calculate_required_xp()
	show_upgrade_screen()
	
## Calculates the required XP for next level up.
func calculate_required_xp() -> void:
	xp_for_level_up = int(3 * pow(5.0 / 3.0, exponent))
	exponent += 1

## Returns an array of 2 random upgrades from [member upgrades] array.
func pick_random_upgrades() -> Array:
	var options: Array = []
	var all_upgrades = upgrades.duplicate(false)
	all_upgrades.shuffle()
	for i in range(2):
		options.append(all_upgrades[i])
	return options

## Shows upgrade screen UI [member upgrade_ui], pausing the game, setting up buttons.
func show_upgrade_screen() -> void:
	get_tree().paused = true
	var upgrade_scene = load("res://upgrade/UpgradeUI.tscn")
	upgrade_ui = upgrade_scene.instantiate() as Control
	upgrade_ui.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().get_root().add_child(upgrade_ui)
	var picked_upgrades = pick_random_upgrades()
	setup_upgrade_buttons(picked_upgrades)

## Sets up the upgrade buttons.
func setup_upgrade_buttons(picked_upgrades: Array) -> void:
	var button_paths = ["Panel/Button", "Panel/Button2"]
	for i in range(2):
		var upgrade_data = picked_upgrades[i]
		var button = upgrade_ui.get_node(button_paths[i]) as Button
		var title_label = button.get_node("TitleLabel") as Label
		var description_label = button.get_node("DescriptionLabel") as Label
		title_label.text = upgrade_data["name"]
		description_label.text = upgrade_data["description"]
		if button.is_connected("pressed", Callable(self, "on_upgrade_button_pressed")):
			button.disconnect("pressed", Callable(self, "on_upgrade_button_pressed"))
		button.pressed.connect(Callable(self, "on_upgrade_button_pressed").bind(upgrade_data["function_name"]))

## Function for when upgrade button is pressed, calls relevant upgrade function.
func on_upgrade_button_pressed(function_name: String) -> void:
	call(function_name) 
	hide_upgrade_screen()

## Hides the upgrade UI and unpauses the game.
func hide_upgrade_screen() -> void:
	upgrade_ui.queue_free()
	upgrade_ui = null
	get_tree().paused = false
		
## Applies max health upgrade to player.
func apply_max_health_upgrade() -> void:
	var player = get_tree().get_first_node_in_group("player")
	player.max_health += 10.0
	print("Upgraded health!")

## Applies bullet speed upgrade to player.
func apply_bullet_speed_upgrade() -> void:
	var player = get_tree().get_first_node_in_group("player")
	player.bullet_speed_multiplier += 0.1
	print("Upgraded bullet speed!")

## Applies damage upgrade to player.
func apply_damage_upgrade() -> void:
	var player = get_tree().get_first_node_in_group("player")
	player.damage_multiplier += 0.1
	print("Upgraded damage!")

## Applies speed upgrade to player.
func apply_speed_upgrade() -> void:
	var player = get_tree().get_first_node_in_group("player")
	player.speed += 5.0
	print("Upgraded speed!")
