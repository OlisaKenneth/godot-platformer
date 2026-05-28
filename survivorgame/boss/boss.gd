extends CharacterBody2D
class_name Boss

@export var max_health: int = 500
@export var move_speed: float = 50
@export var shoot_interval: float = 1.5
@export var bullet_scene: PackedScene  # assign BossBullet.tscn in editor
@export var pattern: int = 1           # 1=Ring, 2=Spiral, 3=Aimed
@export var bullet_count: int = 16     # number of bullets per pattern

var health: int = 0
var shoot_timer: float = 0.0
var angle: float = 0.0
var spiral_angle: float = 0.0

@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	health = max_health

func _process(delta: float) -> void:
	if not player or not is_instance_valid(player):
		return

	# Update timers
	shoot_timer += delta
	spiral_angle += delta * 1.0  # used for spiral rotation

	# Shoot bullets periodically
	if shoot_timer >= shoot_interval:
		shoot_timer = 0.0
		match pattern:
			1: shoot_pattern_ring()
			2: shoot_pattern_spiral()
			3: shoot_pattern_aimed()

func spawn_bullet(dir: Vector2) -> void:
	if not bullet_scene:
		return

	# Instantiate the root Node2D of the bullet scene
	var bullet_root = bullet_scene.instantiate() as Node2D
	bullet_root.global_position = global_position

	# Get the Area2D child to set direction
	var bullet = bullet_root.get_node("Bullet") as BossBullet
	bullet.set_direction(dir)

	get_tree().current_scene.add_child(bullet_root)


# Ring of bullets around the boss
func shoot_pattern_ring() -> void:
	for i in range(bullet_count):
		var dir_angle = (TAU / bullet_count) * i + angle
		spawn_bullet(Vector2(cos(dir_angle), sin(dir_angle)))

# Spiral bullets (rotating bullet ring)
func shoot_pattern_spiral() -> void:
	for i in range(bullet_count):
		var dir_angle = (TAU / bullet_count) * i + spiral_angle
		spawn_bullet(Vector2(cos(dir_angle), sin(dir_angle)))

# Bullets aimed at player
func shoot_pattern_aimed() -> void:
	if not player or not is_instance_valid(player):
		return

	var direction = (player.global_position - global_position).normalized()
	for i in range(bullet_count):
		# Optional: spread bullets slightly
		var spread = deg_to_rad((i - bullet_count/2) * 5)
		var dir = direction.rotated(spread)
		spawn_bullet(dir)

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()

func die() -> void:
	print("Boss defeated!")
	queue_free()
