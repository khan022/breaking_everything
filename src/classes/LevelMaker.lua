LevelMaker = Class{}

-- create a table of bricks for different levels. 

function LevelMaker.createMap(level)
    local bricks = {}

    -- randomly choosing a number of rows
    local numRows = math.random(1, 5)

    -- randomly choosing a number of columns
    local numCols = math.random(7, 13)

    -- lay the bricks in a wall pattern
    for y = 1, numRows do
        for x = 1, numCols do
            b = Brick((x - 1) * 32 + 8 + (13 - numCols) * 16, y * 16)

            table.insert(bricks, b)
        end
    end

    return bricks
end