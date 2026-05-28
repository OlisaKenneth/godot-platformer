# Assignment 3 – Procedural Dungeon + A* Pathfinding  
This project contains my solution for Assignment 3.  
It includes a procedural dungeon generator, a custom A* pathfinding system, and a simple agent that moves around the map based on mouse clicks.

---

## How to Run the Project

1. Open the Godot project in Godot 4.x.
2. The main scene to run is located at: res://Main.tscn
3. When the game starts, you should immediately see:
- A randomly generated dungeon (floors + walls)
- A small agent sprite placed on a random walkable tile
- A “Regenerate” button at the top of the screen

4. Interacting with the project:
- **Left-click** on any walkable tile:  
  The agent will calculate a path and walk to that tile using A*.
- **Left-click on walls or unreachable areas:**  
  The agent will not move.
- **Click the Regenerate Button:**  
  A completely new dungeon is generated and the agent is placed on a new random walkable tile.

---

## File Overview

### Core Scripts
- `DungeonGenerator.gd`  
Handles dungeon creation, drawing, and player interactions.

- `DungeonGrid.gd`  
A simple grid data structure storing walls/floors.

- `Pathfinder.gd`  
A fully custom A* implementation (no Godot A* node used).

- `Agent.gd`  
Controls the movement of the agent along a path.

### Testing (GUT)
- All tests are inside:res://tests/
They verify that A* finds valid paths and correctly handles unreachable goals.

---

## Notes for the Marker

- All functions in the major scripts include short, readable documentation comments.
- The pathfinding and generation systems are fully decoupled.
- A* uses only up, down, left, and right neighbours (no diagonals).
- The project regenerates infinitely through the UI button as required.
- The git log includes only commits related to Assignment 3.

If anything is unclear or does not run as expected, please contact me.
