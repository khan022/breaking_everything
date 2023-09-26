-- using libraries of different types
require 'src/Dependencies'


-- called for setting up all the variables.
function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- seed according to random time
    math.randomseed(os.time())

    -- set the application title bar
    love.window.setTitle('Dx Ball!!!')

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

    -- to get the quads for all textures
    gFrames = {
        ['arrows'] = GenerateQuads(gTextures['arrows'], 24, 24),
        ['paddles'] = GenerateQuadsPaddles(gTextures['main']),
        ['balls'] = GenerateQuadsBalls(gTextures['main']),
        ['bricks'] = GenerateQuadsBricks(gTextures['main']),
        ['hearts'] = GenerateQuads(gTextures['hearts'], 10, 9)
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
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end,
        ['serve'] = function() return ServeState() end,
        ['game-over'] = function() return GameOverState() end,
        ['victory'] = function() return VictoryState() end,
        ['high-scores'] = function() return HighScoreState() end,
        ['enter-high-score'] = function() return EnterHighScoreState() end,
        ['paddle-select'] = function() return PaddleSelectState() end
    }
    gStateMachine:change('start', {
        highScores = loadHighScores()
    })
    
    -- play our music outside of all states and set it to looping
    gSounds['music']:play()
    gSounds['music']:setLooping(true)
    
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

-- function load the highscores
function loadHighScores()
    love.filesystem.setIdentity('dx_ball')

    -- if the filesystem doesn't exist initialize it with random values
    if not love.filesystem.exists('dx_ball.lst') then
        local scores = ''
        for i = 10, 1, -1 do
            scores = scores .. 'SKS\n'
            scores = scores .. tostring(i * 0000) .. '\n'
        end

        love.filesystem.write('dx_ball.lst', scores)
    end

    -- flag for whether we're reading a name or not
    local name = true
    local currentName = nil
    local counter = 1

    -- initialize scores table with at least 10 blank entries
    local scores = {}

    for i = 1, 10 do
        -- blank table; each will hold a name and a score
        scores[i] = {
            name = nil,
            score = nil
        }
    end

    -- iterate over each line in the file, filling in names and scores
    for line in love.filesystem.lines('dx_ball.lst') do
        if name then
            scores[counter].name = string.sub(line, 1, 3)
        else
            scores[counter].score = tonumber(line)
            counter = counter + 1
        end

        -- flip the name flag
        name = not name
    end

    return scores
end

-- rendering the count of health with heart
function renderHealth(health)
    local healthX = VIRTUAL_WIDTH - 100

    -- render health left
    for i = 1, health do
        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][1], healthX, 4)
        healthX = healthX + 11
    end

    -- render missing health
    for i = 1, 3 - health do
        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][2], healthX, 4)
        healthX = healthX + 11
    end
end

-- count and display the FPS on the screen
function displayFPS()

    -- simply display accross all states
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)

end

-- rendering the scores on the screen
function renderScore(score)
    love.graphics.setFont(gFonts['small'])
    love.graphics.print('Score:', VIRTUAL_WIDTH - 60, 5)
    love.graphics.printf(tostring(score), VIRTUAL_WIDTH - 50, 5, 40, 'right')
end