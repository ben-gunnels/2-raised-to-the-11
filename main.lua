local love = require("love")
local board = require("Board")

_G.tilePositions = {}
_G.numRows, _G.numCols = 3, 3
_G.tileSize = 100
_G.gameBoard = board()

_G.gameState = {
    running = true,
    score = 0, 
}

-- the below is so we can make it easier to add fonts to our buttons and text
local fonts = {
    medium = {
        font = love.graphics.newFont(16),
        size = 16
    },
    large = {
        font = love.graphics.newFont(24),
        size = 24
    },
    massive = {
        font = love.graphics.newFont(60),
        size = 60
    }
}

local colors = {
    {215/255, 215/255, 215/255}, -- two
    {221/255, 222/255, 193/255}, -- four
    {255/255, 182/255, 10/255}, -- eight
    {255/255, 149/255, 10/255}, -- sixteen
    {240/255, 148/255, 115/255}, --thirty two
    {255/255, 69/255, 3/255}, -- sixty four
    {255/255, 252/255, 153/255}, -- one twenty eight
    {245/255, 240/255, 93/255}, -- two fifty six
    {255/255, 234/255, 46/255}, -- five twelve
    {255/255, 217/255, 0/255}, -- 1024
    {0/255, 64/255, 255/255} -- 2048!
}

local function deepCopy(a1) 
    local copy = {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}}
    for i= 1, numRows do
        for j = 1, numCols do
            copy[i][j] = a1[i][j]
        end
    end
    return copy     
end

local function arrayEqual(a1, a2)
    -- Check length, or else the loop isn't valid.
    if #a1 ~= #a2 then
      return false
    end
  
    -- Check each element.
    for i = 1, #a1 do
        for j = 1, #a1[1] do
            if a1[i][j] ~= a2[i][j] then
                return false
            end
        end
    end 
    -- We've checked everything.
    return true
  end

function love.load()
    love.window.setMode(600, 600)
    love.window.setTitle("2 raised to the 11")
    _G.boardOffsetX = love.graphics.getWidth() / 2 - 180
    _G.boardOffsetY = 30

    for i = 1, numRows do
        tilePositions[i] = {}
        for j = 1, numCols do
            tilePositions[i][j] = {0, 0} -- Initialize each cell with {0, 0}
        end
    end

    for i = 1, numRows do
        for j = 1, numCols do
            if i == 1 then
                tilePositions[i][j][1] = boardOffsetX + 16
            else
                tilePositions[i][j][1] = boardOffsetX + 16 + ((i-1) * 114)
            end
            if j == 1 then
                tilePositions[i][j][2] = boardOffsetY + 17
            else
                tilePositions[i][j][2] = boardOffsetY + 17 + ((j-1) * 113)
            end
        end
    end
end

function love.keypressed(key)
    if key == "left" or key == "right" or key == "up" or key == "down" then
        local prevBoard = deepCopy(gameBoard.board)
        gameState.score = gameBoard:movePieces(key, gameState.score)
        if not arrayEqual(gameBoard.board, prevBoard) then
            gameBoard:spawnTile()
        end
        if not gameBoard:checkIfValidMoves() then
            gameState.running = false
        end
    elseif key == "space" then
        if gameState.running == false then
            gameState.running = true
            gameBoard = board()
        end
    end
end

function love.update(dt)
end

function love.draw()
    -- draw board
    local boardImg = love.graphics.newImage("/images/2048-board.png")
    love.graphics.draw(boardImg, boardOffsetX, boardOffsetY)

    love.graphics.printf(
        "Score: " .. gameState.score,
        love.graphics.newFont(16),
        10,
        love.graphics.getHeight() - 70,
        love.graphics.getWidth()
    )
    for i = 1, numRows do
        for j = 1, numCols do
            if gameBoard.board[i][j] > 0 then
                local color = math.log(gameBoard.board[i][j]) / math.log(2)
                love.graphics.setColor(colors[color][1], colors[color][2], colors[color][3])
                love.graphics.rectangle("fill", tilePositions[i][j][1], tilePositions[i][j][2], tileSize, tileSize)
                love.graphics.setColor(0, 0, 0)
                love.graphics.printf(gameBoard.board[i][j], love.graphics.newFont(16), tilePositions[i][j][1] + 43, tilePositions[i][j][2] + 43, love.graphics.getWidth())
                love.graphics.setColor(1, 1, 1)
            end
        end
    end

    if not gameState.running then
        love.graphics.setColor(255, 0, 0)
        love.graphics.printf(
            "Game Over! Score: " .. math.floor(gameState.score), 
            fonts.massive.font, 0, 
            love.graphics.getHeight() / 2 - fonts.massive.size, 
            love.graphics.getWidth(), 
            "center")
        love.graphics.setColor(255,255,255)
    end
    -- draw tiles on the board
end
