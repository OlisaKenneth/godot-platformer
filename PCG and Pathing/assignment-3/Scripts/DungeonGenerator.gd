extends Node2D

@export var width: int = 40
@export var height: int = 25
@export var num_steps: int = 600
@export var num_agents: int = 3


@export var floor_source_id: int = 0
@export var floor_atlas_coords: Vector2i = Vector2i(1, 1)

@export var wall_source_id: int = 1
@export var wall_atlas_coords: Vector2i = Vector2i(1, 1)

var dungeon: DungeonGrid
var pathfinder: Pathfinder


@onready var tilemap: TileMapLayer = $DungeonTileMap
@onready var regenerate_button: Button = $RegenerateButton
@onready var agent: Node2D = $Agent

## Called when the scene is ready.
## Sets up the regenerate button and builds an initial dungeon
func _ready() -> void:
	regenerate_button.pressed.connect(_on_regenerate_button_pressed)
	regenerate_dungeon()


## Runs when the user clicks the regenerate button.
## Simply creates a brand new dungeon layout.
func _on_regenerate_button_pressed() -> void:
	regenerate_dungeon()

## Completely refreshes the dungeon:

## Runs the procedural generation (agent digger)



func regenerate_dungeon() -> void:
	## Builds a new blank grid
	dungeon = DungeonGrid.new(width, height)
	_run_agent_digger()
	## Creates a new Pathfinder tied to this grid
	pathfinder = Pathfinder.new(dungeon)
	## Draws the dungeon tiles
	_draw_dungeon()
	## Places the agent on a random walkable tile
	_place_agent_randomly()



# Uses a simple agent-based digging algorithm to carve out floor tiles.
# Each agent walks randomly around the map and digs paths as it moves.
# The result is a cave/dungeon-like structure.
func _run_agent_digger() -> void:
	var agents: Array[Vector2i] = []

	# start agents in the middle of the map
	var start_pos := Vector2i(width / 2, height / 2)
	for i in range(num_agents):
		agents.append(start_pos)

# four possible movement directions
	var dirs = [
		Vector2i(1, 0),
		Vector2i(-1, 0),
		Vector2i(0, 1),
		Vector2i(0, -1)
	]
# walk and dig for a number of steps
	for step in range(num_steps):
		for i in range(agents.size()):
			var pos: Vector2i = agents[i]
			dungeon.set_tile(pos.x, pos.y, 1)  # dig floor

			var dir: Vector2i = dirs[randi() % dirs.size()]
			var new_pos := pos + dir
			if dungeon.is_in_bounds(new_pos.x, new_pos.y):
				agents[i] = new_pos


## Goes through the dungeon grid and places the proper tile at each coordinate.
## This is where the TileMap visually shows floor/wall tiles.
func _draw_dungeon() -> void:
	tilemap.clear()
	for y in range(dungeon.height):
		for x in range(dungeon.width):
			var val := dungeon.get_tile(x, y)
			var cell_pos := Vector2i(x, y)

			if val == 1:
				tilemap.set_cell(cell_pos, floor_source_id, floor_atlas_coords)
			else:
				tilemap.set_cell(cell_pos, wall_source_id, wall_atlas_coords)

func _place_agent_randomly() -> void:
	var walkable: Array[Vector2i] = []

	# collect all floor tiles (1 = floor)
	for y in range(dungeon.height):
		for x in range(dungeon.width):
			if dungeon.is_walkable(x, y):
				walkable.append(Vector2i(x, y))

	
	if walkable.is_empty():
		return

	# pick a random index
	var idx: int = randi() % walkable.size()
	var tile_pos: Vector2i = walkable[idx]

	# tell the Agent to move to that grid position
	agent.set_grid_position(tile_pos, tilemap)
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_handle_left_click(event.position)

func _handle_left_click(mouse_pos: Vector2) -> void:
	# Convert mouse screen position to tile coordinates

	var local_pos: Vector2 = tilemap.to_local(mouse_pos)
	var grid_pos: Vector2i = tilemap.local_to_map(local_pos)


	if not dungeon.is_walkable(grid_pos.x, grid_pos.y):
		return

	# 2) Ask pathfinder for path from agent to clicked tile
	var start_tile: Vector2i = agent.current_tile
	var path: Array[Vector2i] = pathfinder.find_path(start_tile, grid_pos)

	# 3) If no path -> do nothing
	if path.is_empty():
		return

	# 4) Give path to agent so it moves
	agent.set_path(path, tilemap)
