
# GrandM

**GrandM** is a configurable chess-inspired game developed using [Love2D](https://love2d.org/) and Lua. This game introduces a unique twist on traditional chess by allowing players to customize pieces, starting positions, and rogue-like gameplay elements through JSON configuration files.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Gameplay Workflow](#gameplay-workflow)
- [Installation](#installation)
- [Configuration](#configuration)
- [Controls](#controls)
- [Contributing](#contributing)
- [License](#license)

## Overview

GrandM provides a customizable, dynamic chess experience where players can configure their pieces, positions, and certain gameplay elements. The game is designed for fans of chess looking for a unique and configurable experience.

## Features

- **Customizable Game Pieces**: Modify attributes, abilities, and visual styles of pieces via JSON files.
- **Unique Rogue-like Gameplay Elements**: Adds a strategic layer to standard chess rules.
- **Flexible Board Setup**: Set initial configurations for player and computer pieces.
- **JSON-Based Configuration**: Easily customize game settings without modifying code.

## Gameplay Workflow

1. **Game Boot**: The game initializes, loading required resources.
2. **Board Presentation**: A new chessboard appears for players.
3. **Player Piece Placement**: Players can arrange their pieces on valid board positions.
4. **Computer Piece Placement**: Opponent pieces are pre-arranged based on JSON configurations.
5. **Game Start**: Standard chess gameplay begins once all pieces are in position.

## Installation

To play **GrandM**, you’ll need [Love2D](https://love2d.org/) installed on your system.

### Steps

1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/GrandM.git
   cd GrandM
   ```

2. Run the game with Love2D:
   ```bash
   love .
   ```

## Configuration

You can customize gameplay elements through JSON files located in the `config` directory. Here’s a quick overview of configurable components:

- **Piece Configurations**: Modify each piece’s abilities, types, and visual style.
- **Board Configurations**: Customize starting positions and layouts for both player and computer.

## Controls

- **Left-click**: Select and move pieces.
- **Escape**: Pause or return to the main menu.

## Key Components

### `src/board.lua`
- Handles board initialization, drawing, and piece interactions.

### `src/piece.lua`
- Manages piece behaviors, including movement rules and custom abilities.

### `src/game.lua`
- Contains the main game loop, manages state transitions, and handles win/loss conditions.

## Contributing

We welcome contributions! Please fork the repository and submit a pull request with your enhancements or bug fixes.

## License

This project is licensed under the MIT License.
