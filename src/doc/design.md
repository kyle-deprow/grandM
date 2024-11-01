# GrandM Game Design Document

## Overview
GrandM is a configurable chess game built using Love2D. It features customizable game pieces and rogue-like gameplay elements. The game allows players to configure their pieces and positions through JSON files, providing a unique and dynamic chess experience.

## Game Workflow
1. **Game Boot**: Initialize the game environment and load necessary resources.
2. **Board Presentation**: Display a new chess board.
3. **Player Piece Placement**: Player pieces are shown in tile holders below/above the board and can be moved onto valid board positions.
4. **Computer Piece Placement**: Computer pieces are pre-placed based on JSON configuration files.
5. **Game Commencement**: Once pieces are placed on the board, the game proceeds with standard chess rules.

## Key Components

### **Board (`src/board.lua`)**
- **Responsibilities**:
  - Initialize and draw the chess board.
  - Manage piece placement and movement.
  - Handle board-related interactions (e.g., mouse events).
  - Manage tile holders for unplaced pieces.
- **Key Methods**:
  - `new()`: Creates a new board instance with default attributes.
  - `initialize(rows, cols, player1, player2)`: Sets up the board, tile holders, and initializes pieces.
  - `calculateBoardParameters()`: Calculates board dimensions and scaling.
  - `initializeBoard()`: Sets up the board with alternating colors.
  - `initializeTileHolders()`: Creates tile holders for each player.
  - `initializePieces()`: Sets up pieces in tile holders or on board.
  - `initializeTileHolderPiece(piece, position)`: Places piece in tile holder.
  - `initializeBoardPiece(piece, position)`: Places piece on board.
  - `draw()`: Renders the board, pieces, and tile holders.
  - `checkIfWindowSizeChanged()`: Monitors for window resizing.
  - `resetBoard()`, `resetTileHolders()`: Updates positions after window resize.
  - `drawBoard()`, `drawTileHolders()`: Renders board components.
  - `update(dt)`: Updates game state and piece positions.
  - `mousepressed(x, y, button)`, `mousereleased(x, y, button)`: Handles mouse input.

### **TileHolder (`src/tileholder.lua`)**
- **Responsibilities**:
  - Manage a row of tiles for holding unplaced pieces.
  - Handle piece placement and removal.
  - Position tiles relative to the board.
- **Key Methods**:
  - `new(maxPieces, position, boardWidth, tileSize)`: Creates new tile holder.
  - `initializeTiles()`: Sets up initial tile positions.
  - `reset(position, tileSize, boardWidth)`: Updates holder after window resize.
  - `resetTiles()`: Recalculates tile positions.
  - `addPiece(piece)`: Places piece in first available tile.
  - `removePiece(piece)`: Removes piece from holder.
  - `getPieceAtPosition(x, y)`: Returns piece at screen coordinates.
  - `draw()`: Renders holder and contained pieces.
  - `getPieces()`: Returns all pieces in holder.

### **GameManager (`src/manager.lua`)**
- **Responsibilities**:
  - Manage game state and player turns.
  - Initialize and start the game.
- **Key Methods**:
  - `new()`: Creates game manager with players and board.
  - `startGame()`: Initializes game components.
  - `update(dt)`: Updates game logic.
  - `draw()`: Delegates rendering.
  - `keypressed(key)`: Handles keyboard input.
  - `switchTurn()`: Manages turn rotation.

### **Player (`src/player.lua`)**
- **Responsibilities**:
  - Manage player-specific data and pieces.
  - Load player configuration from JSON files.
- **Key Methods**:
  - `new(jsonConfigPath)`: Initializes player from config.
  - `setPieces(pieces)`: Updates player pieces.
  - `getColor()`: Returns player color.
  - `getPieces()`: Returns player pieces.
  - `getPiecesCount()`: Returns number of pieces.
  - `getMaxPieces()`: Returns maximum allowed pieces.
  - `getIsInteractive()`: Returns if player is interactive.

### **Piece (`src/piece.lua`)**
- **Responsibilities**:
  - Represent individual chess pieces.
  - Handle piece-specific actions.
  - Manage piece scaling and positioning.
- **Key Methods**:
  - `new(pieceConfig)`: Creates piece from config.
  - `draw()`: Renders piece with scaling.
  - `calculateScale(tileSize)`: Updates piece scale.
  - `resetPosition()`: Returns to original position.
  - `setPosition(position)`, `getPosition()`: Position management.
  - `setTile(tile)`, `getTile()`: Tile management.
  - `getId()`: Returns piece identifier.
  - `getOriginalPosition()`, `setOriginalPosition()`: Original position management.
  - `getPngSize()`, `getScale()`: Scaling information.
  - `getTexture()`: Returns piece texture.
  - `getStart()`: Returns starting position offsets.

### **Tile (`src/tile.lua`)**
- **Responsibilities**:
  - Represent a single tile on board or in holder.
  - Track tile color and current piece.
  - Calculate piece positioning.
- **Key Methods**:
  - `new(color)`: Creates new tile.
  - `draw()`: Renders tile and piece.
  - `reset(tileSize, topLeftCornerX, topLeftCornerY)`: Updates tile parameters.
  - `calculatePiecePosition()`: Determines piece placement.
  - `getColor()`, `setColor(color)`: Color management.
  - `getPiece()`, `setPiece(piece)`: Piece management.
  - `hasPiece()`: Checks for piece presence.
  - `getTopLeftCorner()`, `setTopLeftCorner(corner)`: Position management.
  - `getTileSize()`, `setTileSize(size)`: Size management.

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
  - Define global constants and paths.
- **Key Constants**:
  - `C`: Color constants including new GRAY color.
  - `TEXTURE_PATH`: Texture resource path.
  - `PLAYER_CONFIG_PATH`: Player config path.
  - `PIECE_OFFSET`: Piece positioning offset.
  - `BOARD_SCALING_FACTOR`: Board size scaling (0.80).
  - `TOP`, `BOTTOM`: Position constants (1, -1).
  - `DEBUG`: Extended debug sections including TILE and TILEHOLDER.

## Future Development
- Implement correct tileholder placement (currently off to the side)
- Implement drag and drop logic from tileholder to board
- Implement move validation logic.
- Enhance piece-specific behaviors.

## Notes
- Tab space sizing is set to 2 spaces.
- Window resizing is now handled automatically.
