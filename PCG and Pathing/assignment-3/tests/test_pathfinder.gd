extends "res://addons/gut/test.gd"

# These tests check that the Pathfinder works with a small, hand-made grid.
# The goal is to show that A* finds a path when one exists, and returns []
# when the destination cannot be reached.

func _make_test_grid() -> DungeonGrid:
	# Make a small 5x5 dungeon
	var g := DungeonGrid.new(5, 5)

	# Fill everything with floors (1)
	for y in range(5):
		for x in range(5):
			g.set_tile(x, y, 1)

	return g


func test_pathfinder_finds_simple_path():
	# Basic setup: everything is walkable
	var g := _make_test_grid()
	var p := Pathfinder.new(g)

	var start := Vector2i(0, 0)
	var goal := Vector2i(4, 4)

	var path := p.find_path(start, goal)

	# Path should NOT be empty
	assert_true(path.size() > 0, "Expected a valid path, got empty list.")

	# Path should start at the start tile
	assert_eq(path[0], start, "Path should begin at the start tile.")

	# Path should end at the goal tile
	assert_eq(path[path.size() - 1], goal, "Path should end at the goal tile.")


func test_pathfinder_returns_empty_when_blocked():
	var g := _make_test_grid()

	# Block everything between start and goal
	# Example wall pattern:

	for x in range(5):
		g.set_tile(x, 2, 0)   # row 2 becomes a wall row

	var p := Pathfinder.new(g)

	var start := Vector2i(0, 0)
	var goal := Vector2i(4, 4)

	var path := p.find_path(start, goal)

	# Since row 2 is entirely walls, bottom area can't be reached
	assert_eq(path.size(), 0, "Expected empty path when goal is unreachable.")
