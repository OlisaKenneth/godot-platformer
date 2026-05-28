extends CharacterBody2D
class_name enemy

@export var speed: float = 40.0
@export var max_health: int = 25
@export var attack_range: float = 50.0
@export var attack_damage: int = 5
@export var attack_interval: float = 1.0
@export var drop_chance: float = 0.3
@export var exp_drop_scene: PackedScene

var health: int

@onready var player = get_tree().get_first_node_in_group("player")


var damageSound: AudioStreamPlayer2D
var deathSound: AudioStreamPlayer2D

var _attack_timer := 0.0


func _ready() -> void:
	health = max_health
	add_to_group("enemies")
	randomize()

	
	damageSound = get_node_or_null("EDamage")
	deathSound  = get_node_or_null("Death")

	# Debug if missing
	if damageSound == null:
		push_warning("Missing EDamage sound node on enemy: %s" % get_path())
	if deathSound == null:
		push_warning("Missing Death sound node on enemy: %s" % get_path())


func _physics_process(delta: float) -> void:
	if not player or not is_instance_valid(player):
		return

	var distance = global_position.distance_to(player.global_position)

	if distance > attack_range:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
	else:
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
	if damageSound:
		damageSound.play()
	if health <= 0:
		die()


func die() -> void:
	# track kills
	GameState.enemies_killed += 1
	# play death sound if it exists
	if deathSound:
		deathSound.play()

	# drop XP if allowed
	if randf() <= drop_chance and exp_drop_scene:
		var pellet = exp_drop_scene.instantiate()
		pellet.global_position = global_position

		var root_scene = get_tree().current_scene
		if root_scene:
			root_scene.add_child(pellet)
		else:
			get_tree().get_root().add_child(pellet)

	queue_free()
