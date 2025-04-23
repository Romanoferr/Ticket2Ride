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
            startCity = fields[1], -- Corrected index
            endCity = fields[2],   -- Corrected index
            points = tonumber(fields[3]) -- Corrected index
        }
        table.insert(destinationTicketCards.tickets, ticket)
    end

    file:close()
end

function destinationTicketCards.draw()
    love.graphics.setColor(1, 1, 1)

    -- Print only the first ticket
    local ticket = destinationTicketCards.tickets[9]
    if ticket then
        local pointsText = ticket.points and tostring(ticket.points) or "N/A" -- Handle nil points - if needed (shouldnt get header)
        love.graphics.print("Ticket: " .. ticket.startCity .. " to " .. ticket.endCity .. " - Points: " .. pointsText, 50, 50)
    end
end

function destinationTicketCards.getTickets()
    return destinationTicketCards.tickets
end

return destinationTicketCards
