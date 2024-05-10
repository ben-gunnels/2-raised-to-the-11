local love = require("love")
math.randomseed(os.time())

function spawnTile(board)
    if math.random() < 0.5 then
        randRow, randCol = math.random(1, 3), math.random(1, 3)
        while board[randRow][randCol] ~= 0 do
            randRow, randCol = math.random(1, 3), math.random(1, 3)
        end
        board[randRow][randCol] = 2
    else
        randRow, randCol = math.random(1, 3), math.random(1, 3)
        while board[randRow][randCol] ~= 0 do
            randRow, randCol = math.random(1, 3), math.random(1, 3)
        end
        board[randRow][randCol] = 4
    end
    return board
end

function checkBoardFull(board)
    local boardFull = true
    for i = 1, 3 do
        for j = 1, 3 do
            if board[i][j] == 0 then
                return false
            end
        end
    end
    return boardFull
end

function checkIfValidMoves(board) 
    local validMoves = false
    if not checkBoardFull(board) then
        return true
    end
    for i = 2, 3 do
        for j = 2, 3 do
            if board[i-1][j] == board[i][j] or board[i][j-1] == board[i][j] then
                validMoves = true
            end
        end
    end
    return validMoves
end

function movePieces(board, dir, score)
    local hasMoved = false
    if dir == "up" then
        for i = 1, 3 do
            for j = 2, 3 do
                if board[i][j-1] == board[i][j] then
                    board[i][j-1] = board[i][j-1] * 2
                    score = score + board[i][j-1] * 2
                    board[i][j] = 0
                elseif board[i][j-1] == 0 then
                    if j == 3 and board[i][j-2] == 0 then
                        board[i][j-2] = board[i][j]
                    elseif j == 3 and board[i][j-2] == board[i][j] then
                        board[i][j-2] = board[i][j-2] * 2
                        score = score + board[i][j-2] * 2
                    else
                        board[i][j-1] = board[i][j]
                    end
                    board[i][j] = 0
                end
            end
        end
    elseif dir == "down" then
        for i = 1, 3 do
            for j = 2, 1, -1 do
                if board[i][j+1] == board[i][j] then
                    board[i][j+1] = board[i][j+1] * 2
                    score = score + board[i][j+1] * 2
                    board[i][j] = 0
                elseif board[i][j+1] == 0 then
                    if j == 1 and board[i][j+2] == 0 then
                        board[i][j+2] = board[i][j]
                    elseif j == 1 and board[i][j+2] == board[i][j] then
                        board[i][j+2] = board[i][j+2] * 2
                        score = score + board[i][j+2] * 2
                    else
                        board[i][j+1] = board[i][j]
                    end
                    board[i][j] = 0
                end
            end
        end
    elseif dir == "right" then
        for i = 2, 1, -1 do
            for j = 1, 3 do
                if board[i+1][j] == board[i][j] then
                    board[i+1][j] = board[i+1][j] * 2
                    score = score + board[i+1][j] * 2
                    board[i][j] = 0
                elseif board[i+1][j] == 0 then
                    if i == 1 and board[i+2][j] == 0 then
                        board[i+2][j] = board[i][j]
                    elseif i == 1 and board[i+2][j] == board[i][j] then
                        board[i+2][j] = board[i][j] * 2
                        score = score + board[i+2][j] * 2
                    else
                        board[i+1][j] = board[i][j]
                    end
                    board[i][j] = 0
                end
            end
        end
    elseif dir == "left" then
        for i = 2, 3 do
            for j = 1, 3 do
                if board[i-1][j] == board[i][j] then
                    board[i-1][j] = board[i-1][j] * 2
                    score = score + board[i-1][j] * 2
                    board[i][j] = 0
                elseif board[i-1][j] == 0 then
                    if i == 3 and board[i-2][j] == 0 then
                        board[i-2][j] = board[i][j]
                    elseif i == 3 and board[i-2][j] == board[i][j] then
                        board[i-2][j] = board[i][j] * 2
                        score = score + board[i-2][j] * 2
                    else
                        board[i-1][j] = board[i][j]
                    end
                    board[i][j] = 0
                end
            end
        end
    end
    return score
end

function Board() 
    local _board = {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}}
    _board = spawnTile(_board)
    _board = spawnTile(_board)
    return {
        board = _board,
        spawnTile = function(self)
            if not checkBoardFull(self.board) then
                spawnTile(self.board)
            end
        end,
        movePieces = function(self, dir, score)
            score = movePieces(self.board, dir, score)
            return score
        end,
        checkIfValidMoves = function(self)
            return checkIfValidMoves(self.board)
        end
    }
end

return Board