-- in order to make different shapes
NONE = 1
SINGLE_PYRAMID = 2
MULTI_PYRAMID = 3

-- pattern for every rows
SOLID = 1           -- all colors the same in this row
ALTERNATE = 2       -- alternate colors
SKIP = 3            -- skip every other block
NONE = 4            -- no blocks this row

LevelMaker = Class{}

-- create a table of bricks for different levels. 

function LevelMaker.createMap(level)
    local bricks = {}

    -- randomly choosing a number of rows
    local numRows = math.random(1, 5)

    -- randomly choosing a number of columns
    local numCols = math.random(7, 13)
    numCols = numCols % 2 == 0 and (numCols + 1) or numCols

    -- highest possible brick color to spawn
    local highestTier = math.min(3, math.floor(level / 5))

    -- highest color of the highest tier
    local highestColor = math.min(5, level % 5 + 3)

    -- lay the bricks in a wall pattern
    -- for y = 1, numRows do
    --     for x = 1, numCols do
    --         b = Brick((x - 1) * 32 + 8 + (13 - numCols) * 16, y * 16)

    --         table.insert(bricks, b)
    --     end
    -- end

    -- lay bricks in different pattern
    for y = 1, numRows do
        -- weather to enable skipping for rows
        local skipPattern = math.random(1, 2) == 1 and true or false

        -- weather to enable color for rows
        local alternatePattern = math.random(1, 2) == 1 and true or false

        -- choose two colors to alternate
        local alternateColor1 = math.random(1, highestColor)
        local alternateColor2 = math.random(1, highestColor)
        local alternateTier1 = math.random(0, highestTier)
        local alternateTier2 = math.random(0, highestTier)

        -- used when a block is skipped
        local skipFlag = math.random(2) == 1 and true or false

        -- used when alternate block is applied
        local alternateFlag = math.random(2) == 1 and true or false

        -- solid color when there is no alternating
        local solidColor = math.random(1, highestColor)
        local solidTier = math.random(0, highestTier)

        for x = 1, numCols do
            if skipPattern and skipFlag then
                -- turn skip off for next itteration
                skipFlag = not skipFlag

                goto continue
            else
                -- flip the flag else
                skipFlag = not skipFlag
            end

            b = Brick((x - 1) * 32 + 8 + (13 - numCols) * 16, y * 16)

            -- if we are alternating check the color and tier
            if alternatePattern and alternateFlag then
                b.color = alternateColor1
                b.tier = alternateTier1
                alternateFlag = not alternateFlag
            else
                b.color = alternateColor2
                b.tier = alternateTier2
                alternateFlag = not alternateFlag
            end

            -- if there is no alternating then get the solid color and tier
            if not alternatePattern then
                b.color = solidColor
                b.tier = solidTier
            end 

            table.insert(bricks, b)

            ::continue::
        end
    end

    -- if this doesn't generate any bricks then try again
    if #bricks == 0 then
        return self.createMap(level)
    else 
        return bricks
    end
end