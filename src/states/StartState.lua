-- have to include the BaseState

StartState = Class{__includes = BaseState}

-- highlighting the "new game" or the "high scores"
local highlighted = 1

function StartState:update(dt)

    -- toggle the highlighted option if we press arrow key
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        highlighted = highlighted == 1 and 2 or 1
        gSounds['paddle-hit']:play()
    end

    -- here if the escape key is pressed the game is quit
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

end

function StartState:render()

    -- title here
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("Dx BALL!!", 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')

    -- instructions
    love.graphics.setFont(gFonts['medium'])

    -- if we're highlighting 1, render that option blue
    if highlighted == 1 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.printf("New Game!", 0, VIRTUAL_HEIGHT / 2 + 70, VIRTUAL_WIDTH, 'center')

    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)

    -- render option 2 blue if we're highlighting that one
    if highlighted == 2 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.printf("High Scores!!!", 0, VIRTUAL_HEIGHT / 2 + 90, VIRTUAL_WIDTH, 'center')


    -- reset the color
    love.graphics.setColor(1, 1, 1, 1)

end