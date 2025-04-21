-- train.lua
local board = require "board"

local train = {}
local selectedTrain = nil
local snapDistance=10

local function snapToConnection(train)
    for _, connection in ipairs(board.connections) do
        local x1, y1 = connection.x1, connection.y1
        local x2, y2 = connection.x2, connection.y2

        -- Calcula a projeção do trem na linhas
        local px, py = train.x, train.y
        local dx, dy = x2 - x1, y2 - y1
        local lengthSquared = dx * dx + dy * dy
        local t = ((px - x1) * dx + (py - y1) * dy) / lengthSquared
        t = math.max(0, math.min(1, t)) -- Clamp t to [0, 1]
        local closestX = x1 + t * dx
        local closestY = y1 + t * dy

        -- checa se trem está próximo o suficiente da linha
        local distance = math.sqrt((closestX - px) ^ 2 + (closestY - py) ^ 2)
        if distance <= snapDistance then
            train.x = closestX
            train.y = closestY
            return
        end
    end
end

function train.load()
    -- Inicializa trens em posições aleatórias
    for i = 1, 10 do
        table.insert(train, {
            x = math.random(50, 750),
            y = math.random(50, 550), 
            radius = 10 -- "raio" de trem
        })
    end
end

function train.update(dt)
    if love.mouse.isDown(1) then -- 
        local mouseX, mouseY = love.mouse.getPosition()

        -- Checa se trem foi clicado
        for _, train in ipairs(train) do
            local dx = mouseX - train.x
            local dy = mouseY - train.y
            if math.sqrt(dx * dx + dy * dy) <= train.radius then
                selectedTrain = train -- trem selecionado
                break
            end
        end
    end

    -- Move selectedTrain para posição do mouse
    if selectedTrain and love.mouse.isDown(1) then
        local mouseX, mouseY = love.mouse.getPosition()
        selectedTrain.x = mouseX
        selectedTrain.y = mouseY

        snapToConnection(selectedTrain)
    end
end

function train.draw()
    for _, train in ipairs(train) do
        love.graphics.setColor(0, 1, 0) 
        love.graphics.circle("fill", train.x, train.y, train.radius)
    end
end

return train