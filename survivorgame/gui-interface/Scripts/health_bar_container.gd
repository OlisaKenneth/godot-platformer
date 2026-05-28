extends HBoxContainer

@onready var health_label = $HealthLabel
@onready var health_progress = $HealthProgress

var max_health = 100
var current_health = 50

func _ready():
	update_health_display(50)  # That's it!

func update_health_display(new_health):
	current_health = clamp(new_health, 0, max_health)
	health_progress.value = current_health
	health_label.text = "Health: %d/%d" % [current_health, max_health]
