extends Node2D
class_name EnemySpawner

@export var enemy_scene: PackedScene
@export var boss_scene: PackedScene
@export var spawn_interval: float = 1.0
@export var max_enemies: int = 5
@export var spawn_radius: float = 400.0
@export var boss_spawn_kills: int = 1  # number of kills before boss appears

var enemies: Array = []
var _timer := 0.0
@onready var player = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	if not player or not is_instance_valid(player):
		return

	_timer += delta
	if _timer >= spawn_interval:
		_timer = 0.0
		heartbeat()

func heartbeat() -> void:
	# Clean up dead enemies
	enemies = enemies.filter(func(e): return e and is_instance_valid(e))

	# Check if we need to spawn the boss
	if not GameState.boss_spawned and GameState.enemies_killed >= boss_spawn_kills:
		spawn_boss()
		GameState.boss_spawned = true
		print("Boss spawned!")
		return  # stop spawning normal enemies while boss exists

	# Spawn normal enemies if under max capacity
	if enemies.size() < max_enemies:
		spawn_enemy()


func spawn_enemy() -> void:
	if enemy_scene == null:
		return

	var angle = randf_range(0.0, TAU)
	var spawn_pos = player.global_position + Vector2(cos(angle), sin(angle)) * spawn_radius

	var enemy = enemy_scene.instantiate()
	enemy.global_position = spawn_pos
	enemy.add_to_group("enemies")

	get_tree().current_scene.add_child(enemy)
	enemies.append(enemy)

	print("Spawned enemy at ", spawn_pos)


func spawn_boss() -> void:
	if boss_scene == null:
		print("Error: boss_scene not assigned!")
		return

	var boss = boss_scene.instantiate()
	boss.global_position = player.global_position + Vector2(0, -100)  # spawn above player
	get_tree().current_scene.add_child(boss)

	print("Boss instance added at ", boss.global_position)
