extends CharacterBody2D
class_name Enemy

@export var speed: float = 40.0
@export var max_health: int = 25
@export var attack_range: float = 200.0   # distance where the enemy stops and attacks
@export var attack_damage: int = 5
@export var attack_interval: float = 1.0 # seconds between attacks
@export var drop_chance: float = 0.3
@export var exp_drop_scene: PackedScene

var health: int
@onready var player = get_tree().get_first_node_in_group("player")

var _attack_timer := 0.0

func _ready() -> void:
	health = max_health
	add_to_group("enemies")
	randomize()

func _physics_process(delta: float) -> void:
	if not player or not is_instance_valid(player):
		return

	var distance = global_position.distance_to(player.global_position)

	if distance > attack_range:
		# Move toward player
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
	else:
		# Stop moving and attacks
		velocity = Vector2.ZERO
		_attack_timer += delta
		if _attack_timer >= attack_interval:
			_attack_timer = 0.0
			attack_player()

func attack_player() -> void:
	
	if player and is_instance_valid(player):
		if player.has_method("take_damage"):
			player.take_damage(attack_damage)

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()

func die() -> void:
	if randf() <= drop_chance and exp_drop_scene:
		var pellet = exp_drop_scene.instantiate()
		pellet.global_position = global_position
		get_tree().current_scene.add_child(pellet)

	queue_free()
