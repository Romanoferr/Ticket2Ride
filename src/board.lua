local json = require "src.libs.dkjson" -- biblioteca JSON para Lua

local board = {
    nodes = {},
    connections = {}
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
    local locations = readjson("src/assets/city_locations.json")
    for index, coords in pairs(locations) do
        board.nodes[index] = { location = index, x = coords[1] * love.graphics.getWidth(), y = coords[2] * love.graphics.getHeight() }
    end

    local connections = readcsv("src/assets/routes.csv")
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

function board.load()
    createGraph()
end

function board.update(dt)
    -- Update board state if needed (e.g., animations, interactions)
end

function board.draw()
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
end

return board
