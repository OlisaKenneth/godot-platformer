# 306 Survivors

A 2D survival game built with Godot 4.4 as part of CMPT 306 – Game Mechanics at the University of Saskatchewan.

## About the Game

306 Survivors is a top-down survival game where the player must stay alive against waves of enemies for as long as possible. The game features a complete game loop including a main menu, active gameplay, and win/lose conditions.

The project was built in two phases — a rapid prototype followed by a full refactor applying software engineering best practices including object-oriented architecture, design patterns, unit testing with GUT, and formal documentation.

## Gameplay

- Survive against progressively harder waves of enemies
- Collect coins to track score
- Game ends when the player is defeated or survives long enough to win
- Complete game loop: main menu → gameplay → game over / win screen

## Features

- Role-based enemy system with spawning logic
- External data structures separating game logic from engine code
- Unit testing using the GUT (Godot Unit Test) framework
- Object-oriented architecture with design patterns
- Formal method documentation using GDScript `##` syntax
- Audio feedback for game events

## Tech Stack

- **Engine:** Godot 4.4
- **Language:** GDScript
- **Testing:** GUT (Godot Unit Test)
- **Version Control:** Git

## Play the Game

Live on itch.io: [https://kennetholisa.itch.io/306-survivors](https://kennetholisa.itch.io/306-survivors)

## Project Structure

```
survivorgame/       # Main game source — player, enemies, scenes, audio
game-clone/         # Prototype/clone used during early development phase
node_2d.tscn        # Main scene entry point
Godot.gitignore     # Godot-specific git ignore rules
```

## Team

Built as a group project for CMPT 306 at the University of Saskatchewan.

## Course Context

This project was the final milestone of CMPT 306 – Game Mechanics. The assignment required teams to pivot a prototype into a complete, polished game loop with proper software engineering practices applied throughout.
