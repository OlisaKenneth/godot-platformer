extends Area2D

@export var exp_amount: int = 5

@onready var pickupSound: AudioStreamPlayer2D = $Pickup

func _on_body_entered(body):
	if body.is_in_group("player"):
		UpgradeManager.add_xp()
		if body.has_method("add_exp"):
			pickupSound.play()
			body.add_exp()
		queue_free()
