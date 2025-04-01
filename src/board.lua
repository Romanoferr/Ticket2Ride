-- board.lua 

local board = {
    nodes = {},
    connections = {}
}

-- this has to be normalized to the size of the board and locations coordinates
local proportions = {
    x = 800 / 100,
    y = 600 / 100
}

-- Função para ler o arquivo CSV e retornar os dados como uma tabela
-- Essa precisa ir pra outro lugar
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

local function createGraph()
    -- Lê os dados do CSV e cria o grafo com informações 
    local locations = readcsv("ticket2ride_singapore_locations.csv")
    for i = 2, #locations do -- i = 2 para pular o header do csv
        local location, x, y = locations[i][1], tonumber(locations[i][2]), tonumber(locations[i][3])
        board.nodes[location] = {x = x, y = y }
    end

    local connections = readcsv("ticket2ride_singapore_connections.csv")
    for i = 2, #connections do -- i = 2 para pular o header do csv
        local place1, place2, length, double_route = connections[i][1], connections[i][2], tonumber(connections[i][3]), connections[i][4]
        table.insert(board.connections, { place1 = place1, place2 = place2, length = length, double_route = double_route})
    end
end

function board.load()
    createGraph()
end

function board.update(dt)
    -- Update board state if needed (e.g., animations, interactions)
end

function board.draw()
    -- TODO: Aqui faz sentido upar a imagem do tabuleiro por trás da imagem dos nós

    -- Desenha conexões
    for _, connection in ipairs(board.connections) do
        local node1 = board.nodes[connection.place1]
        local node2 = board.nodes[connection.place2]
        if node1 and node2 then
            love.graphics.setColor(1, 1, 1) -- Branco para conexões normais
            if connection.double_route == 'Y' then
                love.graphics.setColor(1, 0, 0) -- Vermelho para conexões duplas
            end
            love.graphics.line(node1.x * proportions.x, node1.y * proportions.y, node2.x * proportions.x, node2.y * proportions.y)
        end
    end

    -- Desenha nós
    for _, node in pairs(board.nodes) do
        love.graphics.setColor(0, 0, 1)
        love.graphics.circle("fill", node.x * proportions.x, node.y * proportions.y, 5)
    end
end

return board
