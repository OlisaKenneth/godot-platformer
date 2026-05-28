extends Area2D
class_name BossBullet

@export var speed: float = 250
@export var damage: int = 15
@export var lifetime: float = 5.0

var velocity: Vector2 = Vector2.ZERO
var timer: float = 0.0

func set_direction(direction: Vector2) -> void:
	velocity = direction.normalized() * speed

func _physics_process(delta: float) -> void:
	global_position += velocity * delta
	timer += delta
	if timer >= lifetime:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()
