# DungeonGrid.gd
class_name DungeonGrid
extends Resource

var width: int
var height: int
var tiles: Array = []  # tiles[y][x], 0 = wall, 1 = floor

## Creates a blank grid for the dungeon and fills it with walls.
## This sets up the structure the generator will carve floors into.
func _init(w: int, h: int) -> void:
	width = w
	height = h
	tiles.resize(height)
	for y in range(height):
		tiles[y] = []
		tiles[y].resize(width)
		for x in range(width):
			tiles[y][x] = 0  # start as walls

## Checks if a tile coordinate is inside the dungeon’s bounds.
## Prevents the generator or pathfinder from reading invalid positions.
func is_in_bounds(x: int, y: int) -> bool:
	return x >= 0 and x < width and y >= 0 and y < height


##Changes a tile’s value (0 = wall, 1 = floor).
## Used by the digger during dungeon generation.
func set_tile(x: int, y: int, value: int) -> void:
	if is_in_bounds(x, y):
		tiles[y][x] = value


## Gets the tile at a given position.
## Out-of-bounds reads default to wall for safety.
func get_tile(x: int, y: int) -> int:
	if is_in_bounds(x, y):
		return tiles[y][x]
	return 0  # treat out of bounds as wall


## Returns true if a tile is walkable (a floor tile).
## Used by the pathfinder and agent placement.
func is_walkable(x: int, y: int) -> bool:
	return is_in_bounds(x, y) and tiles[y][x] == 1
