extends Area2D
class_name Bullet

@export var speed: float = 200
var velocity: Vector2 = Vector2.ZERO
@export var damage: int = 10  # damage dealt to enemies

func set_direction(direction: Vector2, speed_multiplier: float = 1.0) -> void:
	velocity = direction.normalized() * speed * speed_multiplier


func _physics_process(delta: float) -> void:
	position += velocity * delta

func _on_body_entered(body: Node2D) -> void:

	if body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		queue_free()
		return
