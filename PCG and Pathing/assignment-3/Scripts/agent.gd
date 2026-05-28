extends Node2D

@export var move_speed: float = 6.0

var current_tile: Vector2i = Vector2i.ZERO
var _path: Array[Vector2i] = []
var _tilemap: TileMapLayer

## Moves the agent to a specific tile and snaps its position correctly.
## Called whenever a new dungeon is generated so the agent starts in a valid spot.
func set_grid_position(tile: Vector2i, tilemap: TileMapLayer) -> void:
	_tilemap = tilemap
	current_tile = tile
	global_position = _tilemap.map_to_local(tile)
	
## Gives the agent a path to follow tile-by-tile.
func set_path(path: Array[Vector2i], tilemap: TileMapLayer) -> void:
	_tilemap = tilemap
	if path.size() > 0 and path[0] == current_tile:
		path.remove_at(0)
	_path = path


## Moves the agent toward the next tile in its path.
## Once a tile is reached, it moves on to the next one until the path is empty.
func _physics_process(delta: float) -> void:
	if _path.is_empty():
		return

	var next_tile: Vector2i = _path[0]
	var target_pos: Vector2 = _tilemap.map_to_local(next_tile)

	var to_target: Vector2 = target_pos - global_position
	var dist: float = to_target.length()

	if dist < 1.0:
		current_tile = next_tile
		_path.remove_at(0)
		return

	var dir: Vector2 = to_target.normalized()
	var tile_size: float = _tilemap.tile_set.tile_size.x
	var step: float = move_speed * tile_size * delta
	if step > dist:
		step = dist

	global_position += dir * step
