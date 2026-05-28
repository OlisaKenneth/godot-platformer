# PlayerStats.gd
extends CharacterBody2D
class_name PlayerStats

@export var max_health: float = 100.0
@export var health: float = 100.0
@export var xp: int = 1
@export var xp_to_next_level: int = 3
@export var level: int = 1

@export var bullet_speed_multiplier: float = 1.0
@export var damage_multiplier: float = 1.0
@export var movement_speed: float = 50.0

signal stats_changed

func _ready() -> void:
	# emit once so UI can initialize
	emit_signal("stats_changed")

func take_damage(amount: float) -> void:
	health = clamp(health - amount, 0.0, max_health)
	emit_signal("stats_changed")

func heal(amount: float) -> void:
	health = clamp(health + amount, 0.0, max_health)
	emit_signal("stats_changed")

func add_xp(amount: int) -> void:
	xp += amount
	if xp >= xp_to_next_level:
		level_up()
	emit_signal("stats_changed")

func level_up() -> void:
	xp = xp - xp_to_next_level
	level += 1
	xp_to_next_level = int(xp_to_next_level * 1.5)
	# example buffs
	max_health += 10
	damage_multiplier += 0.1
	movement_speed += 2.0
	health = max_health
	emit_signal("stats_changed")
