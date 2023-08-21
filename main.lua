-- using libraries of different types
require 'src/Dependencies'


-- called for setting up all the variables.
function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- seed according to random time
    math.randomseed(os.time())

    -- set the application title bar
    love.window.setTitle('Dx Ball!')

    -- initiating retro looking fonts
    gFonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
    }
    love.graphics.setFont(gFonts['small'])

    -- load images as global variables
    gTextures = {
        ['background'] = love.graphics.newImage('graphics/background.png'),
        ['main'] = love.graphics.newImage('graphics/dx_ball.png'),
        ['arrows'] = love.graphics.newImage('graphics/arrows.png'),
        ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
        ['particle'] = love.graphics.newImage('graphics/particle.png')
    }

    -- setting up the virtual sceen with virtual width and height resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- setting up sounds for various actions 
    gSounds = {
        ['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
        ['confirm'] = love.audio.newSource('sounds/confirm.wav', 'static'),
        ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
        ['no-select'] = love.audio.newSource('sounds/no-select.wav', 'static'),
        ['brick-hit-1'] = love.audio.newSource('sounds/brick-hit-1.wav', 'static'),
        ['brick-hit-2'] = love.audio.newSource('sounds/brick-hit-2.wav', 'static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
        ['victory'] = love.audio.newSource('sounds/victory.wav', 'static'),
        ['recover'] = love.audio.newSource('sounds/recover.wav', 'static'),
        ['high-score'] = love.audio.newSource('sounds/high_score.wav', 'static'),
        ['pause'] = love.audio.newSource('sounds/pause.wav', 'static'),

        ['music'] = love.audio.newSource('sounds/music.wav', 'static')
    }

    -- StateMachine to divide the game up into different states. 
    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end
    }
    gStateMachine:change('start')
    
    -- get the keyspressed
    love.keyboard.keysPressed = {}
end

-- resizing the window
function love.resize(w, h)
    push:resize(w, h)
end

-- update the love.update code
function love.update(dt)

    gStateMachine:update(dt)

    -- reset the keyspressed
    love.keyboard.keysPressed = {}

end


-- create the custom function for the keys pressed table
function love.keypressed(key)

    -- add the keys to the table
    love.keyboard.keysPressed[key] = true

end

-- check the key is pressed or not 
function love.keyboard.wasPressed(key)

    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end

end

-- drawing all of the code onto the screen

function love.draw()

    -- draw the start with push
    push:apply('start')

    -- background for all the states
    local backgroundWidth = gTextures['background']:getWidth()
    local backgroundHeight = gTextures['background']:getHeight()

    love.graphics.draw(gTextures['background'],
        -- drawing at the 0, 0 coordinates
        0, 0,
        -- no rotations
        0,
        -- scaling with X, Y coordinates
        VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight -1))

    -- using the StateMachine to render these
    gStateMachine:render()

    -- displaying FPS for debugging
    displayFPS()

    push:apply('end')

end

-- count and display the FPS on the screen
function displayFPS()

    -- simply display accross all states
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)

end