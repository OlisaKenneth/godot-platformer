extends CharacterBody2D

class_name Player

@export var game_over_scene:PackedScene

var speed: float = 50.0

@export var max_health: float = 100.0
@export var health: float = 100.0
var xp: int = 0

var bullets: PackedScene = load("res://bullet/bullet.tscn")
var bullet_speed_multiplier: float = 1.0
var damage_multiplier = 1.0
var firerate = 1
var shotTimer = 0

@onready var shotSound: AudioStreamPlayer2D = $Shoot
@onready var moveSound: AudioStreamPlayer2D = $Move
@onready var damageSound: AudioStreamPlayer2D = $Damage
@onready var musicSound: AudioStreamPlayer2D = $Music

var randomDirection = Vector2.RIGHT

func _physics_process(_delta: float) -> void:
	if (health <= 0):
		free()
		#call to game over screen rght here
		
	var direction = Input.get_vector("left","right","up","down")
	velocity = direction * speed
	
	if (direction != Vector2.ZERO):
		tilt(direction.x)
		if (!moveSound.playing):
			moveSound.play()
	else:
		tilt(0)
	
	shotTimer -= _delta
	if (shotTimer <= 0):
		shotTimer = firerate
		if (get_tree().get_node_count_in_group("enemies") > 0):
			shoot()
			
	
	move_and_slide()
	
func shoot() -> void:
	var enemies = get_tree().get_nodes_in_group("enemies")
	var target_dir = Vector2.ZERO
	var closest_enemy = null
	var closest = INF
	
	for enemy in enemies:
		var dist = global_position.distance_to(enemy.global_position)
		if dist < closest:
			closest = dist
			closest_enemy = enemy
			
	if (closest < 500):
		target_dir = (closest_enemy.global_position - global_position).normalized()
	else:
		target_dir = Vector2.from_angle(randf_range(0,TAU))
		
	var bullet1 = bullets.instantiate()
	bullet1.position = global_position
	bullet1.set_direction(target_dir, bullet_speed_multiplier)
	get_tree().current_scene.add_sibling(bullet1)
	
	shotSound.play()


func take_damage(amount: int) -> void:
	health -= amount
	damageSound.play()

	if health <= 0:
		_game_over()


func _game_over() -> void:

	# Load and show the Game Over screen
	get_tree().change_scene_to_file("res://game_over/game_over_screen.tscn")


	# Remove the player so they stop moving / shooting
	queue_free()



func tilt(dir) -> void:
	rotation = lerp_angle(rotation,0.5*dir,0.1)
	
func set_health(num: int) -> void:
	damageSound.play()
	health = num

func set_max_health(num: int) -> void:
	max_health = num

func set_xp(num: int) -> void:
	xp = num
