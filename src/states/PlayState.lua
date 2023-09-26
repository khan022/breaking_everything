PlayState = Class{__includes = BaseState}

-- function PlayState:init()
--     self.paddle = Paddle()

--     -- initialize ball with random skin
--     self.ball = Ball(math.random(7))

--     -- giving the ball random velocity
--     self.ball.dx = math.random(-200, 200)
--     self.ball.dy = math.random(-50, -60)

--     -- position the ball in the middle at start
--     self.ball.x = VIRTUAL_WIDTH / 2 - 2
--     self.ball.y = VIRTUAL_HEIGHT - 42  

--     -- use the "static" createMap function to generate a bricks table
--     self.bricks = LevelMaker.createMap()
-- end

-- changing the initialize state with the enter
function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.ball = params.ball
    self.level = params.level

    -- give ball random starting velocity
    self.ball.dx = math.random(-200, 200)
    self.ball.dy = math.random(-50, -60)
end

function PlayState:update(dt)
    if self.paused then
        -- return to the start screen if we press escape
        if love.keyboard.wasPressed('escape') then
            gSounds['wall-hit']:play()
        
            gStateMachine:change('start', {
                highScores = self.highScores
            })
        end
        
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    -- update positions of ball and paddle based on velocity
    self.paddle:update(dt)
    self.ball:update(dt)

    -- check collision
    if self.ball:collides(self.paddle) then
        -- raise the ball above the paddle
        self.ball.y = self.paddle.y - 8
        self.ball.dy = -self.ball.dy

        -- tweak the angle of the ball based on the position it hits the paddle

        -- if we hit the paddle on the left side
        if self.ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
            self.ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - self.ball.x))

        -- if we hit the paddle on the right side
        elseif self.ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
            self.ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - self.ball.x))
        end

        gSounds['paddle-hit']:play()
    end

    -- check collision with the bricks 
    for k, brick in pairs(self.bricks) do
        -- only check if we are inPlay
        if brick.inPlay and self.ball:collides(brick) then

            -- add score
            self.score = self.score + (brick.tier * 200 + brick.color * 25)

            -- trigger the brick hit function
            brick:hit()

            -- go to the victory screen if there are no bricks left
            if self:checkVictory() then
                gSounds['victory']:play()

                gStateMachine:change('victory',{
                    level = self.level,
                    paddle = self.paddle,
                    health = self.health,
                    score = self.score,
                    highScores = self.highScores,
                    ball = self.ball
                })
            end

            -- collision codes for bricks
            -- left edge
            if self.ball.x + 2 < brick.x and self.ball.dx > 0 then
                -- flip the x velocity and reset the position of the ball
                self.ball.dx = -self.ball.dx
                self.ball.x = brick.x - 8
            -- right edge
            elseif self.ball.x + 6 < brick.x + brick.width and self.ball.dx < 0 then
                -- flip the x velocity and reset the position of the ball
                self.ball.dx = -self.ball.dx
                self.ball.x = brick.x + 32
            
            -- top edge if no collision
            elseif self.ball.y < brick.y then
                -- flip y velocity and reset the position
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y - 8
            
            else

                -- flip y velocity and reset position outside of brick
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y + 16
            end

            -- scale and increase the velocity of the ball
            self.ball.dy = self.ball.dy * 1.02

            -- only allowing collision with one brick, when the corner's hit
            break
        end
    end

    -- check if the ball drops below the screen
    if self.ball.y >= VIRTUAL_HEIGHT then
        self.health = self.health - 1
        gSounds['hurt']:play()

        if self.health == 0 then
            gStateMachine:change('game-over', {
                score = self.score,
                highScores = self.highScores
            })
        else
            gStateMachine:change('serve', {
                paddle = self.paddle,
                bricks = self.bricks,
                health = self.health,
                score = self.score,
                highScores = self.highScores,
                level = self.level
            })
        end
    end

    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    -- if love.keyboard.wasPressed('escape') then
    --     love.event.quit()
    -- end
end

function PlayState:render()
    -- render the bricks
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    -- render all particle systems
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    self.paddle:render()
    self.ball:render()

    renderScore(self.score)
    renderHealth(self.health)

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED!!", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end

-- check victory if all the bricks are gone
function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end 
    end

    return true
end