# Pathfinder.gd
class_name Pathfinder
extends Resource

var dungeon: DungeonGrid

## Stores a reference to the dungeon so the pathfinder can read walkability.
func _init(d: DungeonGrid) -> void:
	dungeon = d

## Simple helper: checks whether a tile can be walked on.
func _is_walkable(tile: Vector2i) -> bool:
	return dungeon.is_walkable(tile.x, tile.y)

## Returns all valid, walkable neighbours of a tile (up, down, left, right).
## No diagonal movement allowed for this assignment.
func _get_neighbours(tile: Vector2i) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	var dirs = [
		Vector2i(1, 0),
		Vector2i(-1, 0),
		Vector2i(0, 1),
		Vector2i(0, -1)
	]
	for dir in dirs:
		var n: Vector2i = tile + dir
		if _is_walkable(n):
			result.append(n)
	return result

## Manhattan distance heuristic used by A*.
## Gives a simple estimate of distance without diagonals.
func _heuristic(a: Vector2i, b: Vector2i) -> float:
	# Manhattan distance: no diagonals
	return abs(a.x - b.x) + abs(a.y - b.y)



## Main A* search.
## Returns the shortest path from start to goal as a list of tile coords,
## or an empty list if no path exists.
func find_path(start: Vector2i, goal: Vector2i) -> Array[Vector2i]:
	# If start/goal are not walkable, no path
	if not _is_walkable(start) or not _is_walkable(goal):
		return []

	var open_set: Array[Vector2i] = []
	open_set.append(start)

	var came_from: Dictionary = {}

	var g_score: Dictionary = {}
	var f_score: Dictionary = {}

	g_score[start] = 0.0
	f_score[start] = _heuristic(start, goal)

	while not open_set.is_empty():
		var current: Vector2i = _get_lowest_f(open_set, f_score)

		if current == goal:
			return _reconstruct_path(came_from, current)

		open_set.erase(current)

		for neighbour in _get_neighbours(current):
			var tentative_g: float = g_score.get(current, INF) + 1.0

			if tentative_g < g_score.get(neighbour, INF):
				came_from[neighbour] = current
				g_score[neighbour] = tentative_g
				f_score[neighbour] = tentative_g + _heuristic(neighbour, goal)

				if neighbour not in open_set:
					open_set.append(neighbour)

	# No path found
	return []

## Finds the tile in the open set with the lowest f-score.
func _get_lowest_f(open_set: Array[Vector2i], f_score: Dictionary) -> Vector2i:
	var best: Vector2i = open_set[0]
	var best_score: float = f_score.get(best, INF)

	for node in open_set:
		var score: float = f_score.get(node, INF)
		if score < best_score:
			best = node
			best_score = score

	return best

## Rebuilds the path by walking backwards from the goal tile.
func _reconstruct_path(came_from: Dictionary, current: Vector2i) -> Array[Vector2i]:
	var path: Array[Vector2i] = [current]
	while came_from.has(current):
		current = came_from[current]
		path.push_front(current)
	return path
