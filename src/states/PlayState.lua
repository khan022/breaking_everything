PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.paddle = Paddle()

    -- initialize ball with random skin
    self.ball = Ball(math.random(7))

    -- giving the ball random velocity
    self.ball.dx = math.random(-200, 200)
    self.ball.dy = math.random(-50, -60)

    -- position the ball in the middle at start
    self.ball.x = VIRTUAL_WIDTH / 2 - 2
    self.ball.y = VIRTUAL_HEIGHT - 42  

    -- use the "static" createMap function to generate a bricks table
    self.bricks = LevelMaker.createMap()
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    -- update positions of ball and paddle based on velocity
    self.paddle:update(dt)
    self.ball:update(dt)

    -- check collision
    if self.ball:collides(self.paddle) then
        self.ball.dy = -self.ball.dy
        gSounds['paddle-hit']:play()
    end

    -- check collision with the bricks 
    for k, brick in pairs(self.bricks) do
        -- only check if we are inPlay
        if brick.inPlay and self.ball:collides(brick) then
            -- trigger the brick hit function
            brick:hit()
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    -- render the bricks
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    self.paddle:render()
    self.ball:render()

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED!!", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end