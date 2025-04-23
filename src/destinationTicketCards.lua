local destinationTicketCards = {}

function destinationTicketCards.load()
    destinationTicketCards.tickets = {}

    local file = love.filesystem.newFile("assets/tickets.csv", "r")
    if not file then
        error("Failed to open tickets.csv")
    end

    for line in file:lines() do
        local fields = {}
        for field in line:gmatch("[^,]+") do
            table.insert(fields, field)
        end

        local ticket = {
            startCity = fields[1],
            endCity = fields[2], 
            points = tonumber(fields[3])
        }
        table.insert(destinationTicketCards.tickets, ticket)
    end

    file:close()
end

function destinationTicketCards.draw()
    love.graphics.setColor(1, 1, 1)

    -- testando um unico ticket
    local randomTicket = destinationTicketCards.tickets[24]
    love.graphics.print("Random Ticket: " .. randomTicket.startCity .." to " .. randomTicket.endCity .. " - Points: " .. randomTicket.points, 50, 50)
end

function destinationTicketCards.getTickets()
    return destinationTicketCards.tickets
end

return destinationTicketCards
