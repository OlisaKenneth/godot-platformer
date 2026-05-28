extends Control

@onready var player = get_tree().get_first_node_in_group("player")

@onready var health_label = $StatsPanel/StatsContainer/HealthLabel
@onready var xp_label = $StatsPanel/StatsContainer/XPLabel
@onready var max_health_label = $StatsPanel/StatsContainer/MaxHealthLabel
@onready var bullet_speed_label = $StatsPanel/StatsContainer/BulletSpeedLabel
@onready var damage_label = $StatsPanel/StatsContainer/DamageLabel
@onready var movement_label = $StatsPanel/StatsContainer/DamageLabel

func update_stats_ui() -> void:
	health_label.text = "Health: " + str(player.health) + " / 100.0"
	xp_label.text = "XP: " + str(UpgradeManager.xp) + " / " + str(UpgradeManager.xp_for_level_up)
	max_health_label.text = "Max Health: " + str(player.max_health)
	bullet_speed_label = "Bullet Speed Multiplier: " + str(player.bullet_speed_multiplier)
	damage_label = "Damage Multiplier: " + str(player.damage_multiplier)
	movement_label = "Movement Speed: " + str(player.speed)

func _process(_delta: float) -> void:
	update_stats_ui()
