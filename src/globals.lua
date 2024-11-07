require("tools/util")
C = {
  MULT = HEX('FE5F55'),
  CHIPS = HEX("009dff"),
  MONEY = HEX('f3b958'),
  XMULT = HEX('FE5F55'),
  FILTER = HEX('ff9a00'),
  BLUE = HEX("009dff"),
  RED = HEX('FE5F55'),
  GREEN = HEX("4BC292"),
  PALE_GREEN = HEX("56a887"),
  ORANGE = HEX("fda200"),
  IMPORTANT = HEX("ff9a00"),
  GOLD = HEX('eac058'),
  YELLOW = {1,1,0,1},
  CLEAR = {0, 0, 0, 0}, 
  WHITE = {1,1,1,1},
  PURPLE = HEX('8867a5'),
  BLACK = HEX("374244"),--4f6367"),
  L_BLACK = HEX("4f6367"),
  GRAY = {0.5, 0.5, 0.5, 1},
  CHANCE = HEX("4BC292"),
  JOKER_GREY = HEX('bfc7d5'),
  VOUCHER = HEX("cb724c"),
  BOOSTER = HEX("646eb7"),
  EDITION = {1,1,1,1},
  DARK_EDITION = {0,0,0,1},
  ETERNAL = HEX('c75985'),
  PERISHABLE = HEX('4f5da1'),
  RENTAL = HEX('b18f43')
}

TEXTURE_PATH = "resources/textures/150/"
PLAYER_CONFIG_PATH = "json/players/"

INVALID_TILE_ALPHA = 0.3
LEFT_CLICK = 1
BOARD_SCALING_FACTOR = 0.70
TILE_HOLDER_OFFSET_Y_FACTOR = 0.2
TOP = 1
BOTTOM = -1

DRAG_DAMPING = 0.50
DRAG_ACCELERATION = 300

-- Debug configurations
DEBUG = {
    ENABLED = true,  -- Master switch
    SECTIONS = {
        FILE_PATHS = false,
        BOARD = true,
        PIECE = true,
        MANAGER = true,
        PLAYER = false,
        TILE = true,
        TILEHOLDER = false,
        GAME = false
    }
}
