local train = require "train"
local players = require "players"
local popup = require "libs.popup"
local json = require "libs.dkjson" -- biblioteca JSON para Lua
local lovebird = require "libs.lovebird"

local board = {
    nodes = {},
    connections = {},
    pointerCursor = nil,
    defaultCursor = nil,
    hoveredConnection = nil,
    background = nil,
    scaleX = nil,
    scaleY = nil,
}

-- Função para ler arquivos CSV
local function readcsv(filename)
    local data = {}
    for line in love.filesystem.lines(filename) do
        local fields = {}
        for field in line:gmatch("[^,]+") do
            table.insert(fields, field)
        end
        table.insert(data, fields)
    end
    return data
end

-- Função para ler arquivos JSON
local function readjson(filename)
    local content = love.filesystem.read(filename)
    if not content then
        error("Failed to read file: " .. filename)
    end
    return json.decode(content)
end

-- Funcao para encontrar um nó pelo local
local function findNodeByLocation(location)
    for _, node in pairs(board.nodes) do
        if node.location == location then
            return node
        end
    end
    return nil
end

-- Funcao para calcular o vetor perpendicular
local function calculatePerpendicular(dx, dy, offset)
    local perpendicular = { -dy, dx }
    local length = math.sqrt(perpendicular[1]^2 + perpendicular[2]^2)
    return { perpendicular[1] / length * offset, perpendicular[2] / length * offset }
end

-- Função que efetivamente cria o grafo
local function createGraph()
    local locations = readjson("assets/city_locations.json")
    for index, coords in pairs(locations) do
        board.nodes[index] = { location = index, x = coords[1] * love.graphics.getWidth(), y = coords[2] * love.graphics.getHeight() }
    end

    local connections = readcsv("assets/routes.csv")
    local connectionMap = {}
    for i = 2, #connections do -- Skip header
        local cityA, cityB, distance, color = connections[i][1], connections[i][2], tonumber(connections[i][3]), connections[i][4]
        local key = cityA < cityB and (cityA .. "-" .. cityB) or (cityB .. "-" .. cityA)
        connectionMap[key] = (connectionMap[key] or 0) + 1

        local nodeA = findNodeByLocation(cityA)
        local nodeB = findNodeByLocation(cityB)

        if nodeA and nodeB then
            local dx, dy = (nodeB.x - nodeA.x), (nodeB.y - nodeA.y)
            local totalLength = math.sqrt(dx^2 + dy^2)
            local shortenFactor = 20
            local shortenRatio = shortenFactor / totalLength
            local x1 = nodeA.x + dx * shortenRatio
            local y1 = nodeA.y + dy * shortenRatio
            local x2 = nodeB.x - dx * shortenRatio
            local y2 = nodeB.y - dy * shortenRatio

            local offset = 8 * (connectionMap[key] - 1)
            local perpendicular = calculatePerpendicular(dx, dy, offset)
            local sx1 = x1 + perpendicular[1]
            local sy1 = y1 + perpendicular[2]   
            local sx2 = x2 + perpendicular[1]
            local sy2 = y2 + perpendicular[2]
            table.insert(board.connections, { x1 = sx1, y1 = sy1, x2 = sx2, y2 = sy2, color = color, distance = distance })
        end
    end
end

-- Verifica se o ponto (mx, my) está próximo da linha (x1, y1)-(x2, y2)
local function isMouseNearConnection(mx, my, x1, y1, x2, y2, threshold)
    -- Vetor da linha
    local dx, dy = x2 - x1, y2 - y1
    local lengthSquared = dx * dx + dy * dy
    if lengthSquared == 0 then
        return false
    end

    -- Projeção escalar do ponto na linha (limitada entre 0 e 1)
    local t = ((mx - x1) * dx + (my - y1) * dy) / lengthSquared
    t = math.max(0, math.min(1, t))

    -- Ponto mais próximo da linha ao ponto do mouse
    local closestX = x1 + t * dx
    local closestY = y1 + t * dy

    -- Distância entre o ponto do mouse e o ponto mais próximo da linha
    local dist = math.sqrt((mx - closestX)^2 + (my - closestY)^2)
    return dist <= threshold
end

function board.load()
    board.pointerCursor = love.mouse.getSystemCursor("hand")
    board.defaultCursor = love.mouse.getSystemCursor("arrow")
    board.background = love.graphics.newImage("assets/board.jpeg")

    -- Pega o tamanho da tela
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    -- Pega o tamanho da imagem
    local imgWidth = board.background:getWidth()
    local imgHeight = board.background:getHeight()

    -- Calcula escala para caber na tela
    board.scaleX = screenWidth / imgWidth
    board.scaleY = screenHeight / imgHeight

    createGraph()
end

function board.update(dt)
    -- Update board state if needed (e.g., animations, interactions)
end

function board.draw()
    love.graphics.draw(board.background, 0, 0, 0, board.scaleX, board.scaleY)

    local colorMap = {
        R = {1, 0, 0}, -- Red
        B = {0, 0, 1}, -- Blue
        G = {0, 1, 0}, -- Green
        Y = {1, 1, 0}, -- Yellow
        O = {1, 0.5, 0}, -- Orange
        P = {0.5, 0, 0.5}, -- Purple
        K = {0, 0, 0}, -- Black
        W = {1, 1, 1}  -- White
    }

    for _, connection in ipairs(board.connections) do
        local color = colorMap[connection.color] or {0.5, 0.5, 0.5}
        love.graphics.setColor(color)
        love.graphics.line(connection.x1, connection.y1, connection.x2, connection.y2)
        love.graphics.print(connection.distance, (connection.x1 + connection.x2) / 2, (connection.y1 + connection.y2) / 2, 0, 1, 1, 0, 0)
    end

    for _, node in pairs(board.nodes) do
        love.graphics.setColor(0, 0, 1)
        love.graphics.circle("fill", node.x, node.y, 5)
    end

    if board.hoveredConnection then
        love.graphics.setColor(1, 1, 1)
        love.graphics.setLineWidth(4)
        love.graphics.line(board.hoveredConnection.x1, board.hoveredConnection.y1, board.hoveredConnection.x2, board.hoveredConnection.y2)
        love.graphics.setLineWidth(1)
    end
end

function board.getConnectionUnderMouse(mx, my)
    local threshold = 10 -- pixels de tolerância
    for _, connection in ipairs(board.connections) do
        if isMouseNearConnection(mx, my, connection.x1, connection.y1, connection.x2, connection.y2, threshold) then
            return connection
        end
    end
    return nil
end


-- Tratamento de cliques
function board.mousepressed(x, y, button)
    if button ~= 1 then return end

    local connection = board.getConnectionUnderMouse(x, y)
    if not connection then
        return
    end
    
    lovebird.print("Rota clicada entre:", connection.x1, connection.y1, "e", connection.x2, connection.y2, "distância:", connection.distance)

    local currentPlayer = players.getCurrent()
    
    
    local playerCardsColor = 0
    local cardColor = nil

    if connection.color == "X" then
        playerCardsColor, cardColor = players.countMaxTrainCards(currentPlayer.id)
    else
        playerCardsColor = players.countTrainCardsByColor(currentPlayer.id, connection.color)
    end

    if playerCardsColor ~= connection.distance then
        popup.show(
            "Você não possui cartas suficiente.",  -- Mensagem
            "Ok",  -- Texto do botão
            nil,  -- Nenhum texto para o segundo botão
            function() 
                return
            end,
            nil
        )
        return
    end
    
    if currentPlayer.canConquerRoute then
        popup.show(
            "Você deseja conquistar a rota selecionada?.",  -- Mensagem
            "Sim",  -- Texto do botão
            "Não",  -- Nenhum texto para o segundo botão
            function()
                local colorToRemove = nil
                if not cardColor then colorToRemove = connection.color else colorToRemove = cardColor end
                
                players.removeCardsFromPlayerDeckByColor(currentPlayer.id, colorToRemove)
                train.conquer(connection, currentPlayer.id)
                players.next()
            end,
            function() 
                return
            end
        )
    else
        popup.show(
            "Você já comprou carta nessa rodada.",  -- Mensagem
            "Ok",  -- Texto do botão
            nil,  -- Nenhum texto para o segundo botão
            function() 
                return
            end,
            nil
        )
    end

    return
end

-- Tratamento de movimento, mudança de cursor para feedback ao usuário
function board.mousemoved(x, y, dx, dy)
    board.hoveredConnection = board.getConnectionUnderMouse(x, y)
    if board.hoveredConnection then
        love.mouse.setCursor(board.pointerCursor)
    else
        love.mouse.setCursor(board.defaultCursor)
    end
end

return board
