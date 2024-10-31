# GrandM Game Design Document

## Overview
LuaChess is a configurable chess game built using Love2D. It features customizable game pieces and rogue-like gameplay elements. The game allows players to configure their pieces and positions through JSON files, providing a unique and dynamic chess experience.

## Game Workflow
1. **Game Boot**: Initialize the game environment and load necessary resources.
2. **Board Presentation**: Display a new chess board.
3. **Player Piece Placement**: Player pieces are shown below the board and can be moved onto valid board positions.
4. **Computer Piece Placement**: Computer pieces are pre-placed based on JSON configuration files.
5. **Game Commencement**: Once pieces are placed on the board, the game proceeds with standard chess rules.

## Key Components

### **Board (`src/board.lua`)**
- **Responsibilities**:
  - Initialize and draw the chess board.
  - Manage piece placement and movement.
  - Handle board-related interactions (e.g., mouse events).
- **Key Methods**:
  - `new()`: Creates a new board instance with default attributes.
  - `initializeBoard(rows, cols, player1, player2)`: Sets up the board with alternating colors and initializes pieces for both players.
  - `draw()`: Renders the board and pieces.
  - `initializePieces()`: Positions non-interactive players' pieces below or above the board.
  - `drawBoard()`: Draws the board tiles with alternating colors.
  - `drawPieces()`: Draws the pieces on the board.
  - `update(dt)`: Updates the board state, handling piece dragging for interactive players.
  - `mousepressed(x, y, button)`: Initiates piece dragging when the left mouse button is pressed.
  - `initializeInteractivePiece(piece, index, topbottom)`: Sets up initial position for interactive pieces.
  - `initializeNonInteractivePiece(piece, topbottom)`: Sets up initial position for non-interactive pieces.
  - `movePiece(piece, destTile)`: Handles piece movement between tiles.
  - `mousereleased(x, y, button)`: Finalizes piece placement, checking for valid moves.
  - `isMouseOverPiece(piece, x, y)`: Checks if the mouse is over a specific piece.
  - `getBoardPosition(x, y)`: Converts screen coordinates to board coordinates.
  - `isValidMove(piece, x, y)`: Placeholder for move validation logic.

### **GameManager (`src/manager.lua`)**
- **Responsibilities**:
  - Manage game state and player turns.
  - Initialize and start the game.
- **Key Methods**:
  - `new()`: Creates a new game manager instance, initializing players and the board.
  - `startGame()`: Initializes players and board, setting the game state to "playing".
  - `update(dt)`: Updates game logic during the "playing" state.
  - `draw()`: Delegates drawing to the board.
  - `keypressed(key)`: Handles key inputs, such as switching turns.
  - `switchTurn()`: Switches the active player, allowing for turn-based gameplay.

### **Player (`src/player.lua`)**
- **Responsibilities**:
  - Manage player-specific data and pieces.
  - Load player configuration from JSON files.
- **Key Methods**:
  - `new(jsonConfigPath)`: Initializes a player with pieces from a JSON configuration.
  - `setPieces(pieces)`: Sets the player's pieces.
  - `getColor()`: Returns the player's color.
  - `getPieces()`: Returns the player's pieces.

### **Piece (`src/piece.lua`)**
- **Responsibilities**:
  - Represent individual chess pieces with attributes and behaviors.
  - Handle piece-specific actions like movement and drawing.
  - Extends from Sprite class for rendering functionality.
- **Key Methods**:
  - `new(pieceConfig)`: Creates a new piece instance with attributes from configuration (color, type, rank, health, defense, items).
  - `init(...)`: Calls the parent Sprite class's init method.
  - `getValidMoves(board)`: Placeholder for getting valid moves; should be overridden by specific piece types.
  - `move(newPosition)`: Updates the piece's position.
  - `draw()`: Renders the piece's texture on the board.
  - `render(x, y)`: Draws the piece's texture at a specified position.
  - `resetPosition()`: Resets the piece's position to its original position.
  - `setPosition(position)`: Sets the piece's current position.
  - `getPosition()`: Returns the piece's current position.
  - `getOriginalPosition()`: Returns the piece's original position.
  - `setOriginalPosition(position)`: Sets the piece's original position.
  - `getType()`: Returns the piece type.
  - `getColor()`: Returns the piece color.
  - `getTexture()`: Returns the piece texture.
  - `getStart()`: Returns the piece starting position offsets.
  - `getTile()`: Returns the current tile the piece is on.

### **Tile (`src/tile.lua`)**
- **Responsibilities**:
  - Represent a single tile on the chess board
  - Track tile color and current piece
  - Calculate piece positioning within the tile
  - Manage tile dimensions and position
- **Key Methods**:
  - `new(color)`: Creates a new tile with specified color
  - `calculatePiecePosition()`: Determines the correct position for a piece within the tile
  - `getColor()`, `setColor(color)`: Color management
  - `getPiece()`, `setPiece(piece)`: Piece management
  - `hasPiece()`: Check if tile contains a piece
  - `getTopLeftCorner()`, `setTopLeftCorner(corner)`: Manage tile position
  - `getTileSize()`, `setTileSize(size)`: Manage tile dimensions

### **Position (`src/tools/position.lua`)**
- **Responsibilities**:
  - Utility class for managing x,y coordinates
  - Provide position comparison and copying functionality
- **Key Methods**:
  - `new(x, y)`: Creates a new position
  - `copy(pos)`: Copies values from another position
  - `getX()`, `getY()`: Coordinate getters
  - `setX(x)`, `setY(y)`: Individual coordinate setters
  - `set(x, y)`: Set both coordinates at once
  - `isUninitialized()`, `isDefault()`: Check if position is at (0,0)
  - `__eq`: Equality comparison metamethod
  - `__tostring`: String representation for debugging

### **Utility Functions (`src/tools/util.lua`)**
- **Responsibilities**:
  - Provide utility functions for debugging, color conversion, and file handling.
- **Key Functions**:
  - `DebugPrint(section, ...)`: Prints debug messages for specified sections when debugging is enabled.
  - `HEX(hex)`: Converts a hexadecimal color string to a table of normalized RGBA values.
  - `DebugPrintFilesInPath(path)`: Debug utility to list files in a directory.
  - `ReturnPieceTextureFile(piece)`: Constructs the file path for a piece's texture file.
  - `ReturnPlayerConfigFile(configName)`: Constructs the file path for a player's configuration JSON file.
  - `ReturnJsonConfig(jsonConfigPath)`: Reads and decodes a JSON configuration file, with error handling.

### **Piece Factory (`src/tools/piece_factory.lua`)**
- **Responsibilities**:
  - Create chess piece instances from configuration data.
- **Key Functions**:
  - `CreatePieceFromConfig(pieceConfig)`: Factory function that creates a piece instance based on a JSON configuration object. It maps the piece type to the corresponding class and returns an instance of that class.

### **Global Constants (`src/globals.lua`)**
- **Responsibilities**:
  - Define global constants and paths used throughout the game.
- **Key Constants**:
  - `C`: Table of color constants.
  - `TEXTURE_PATH`: Path to texture resources.
  - `PLAYER_CONFIG_PATH`: Path to player configuration files.
  - `PIECE_OFFSET`: Offset value for initial piece positions.

## Future Development
- Continue debugging until board and pawns are working.
- Implement logic for validating moves in `Board:isValidMove()`.
- Enhance piece-specific behaviors by overriding `Piece:getValidMoves()`.

## Notes
- Tab space sizing is set to 2 spaces.