Paddle = Class{}

-- paddle will initialize at the middle of the screen always

function Paddle:init(skin)

    self.x = VIRTUAL_WIDTH / 2 - 32
    self.y = VIRTUAL_HEIGHT - 32

    -- at start there is no velocity
    self.dx = 0

    self.width = 64
    self.height = 16

    -- skin changes paddle color
    self.skin = skin

    -- varying the paddle size. at start it start at size 2
    self.size = 2

end

-- update function to move the paddle

function Paddle:update(dt)
    -- keyboard input
    if love.keyboard.isDown('left') then
        self.dx = -PADDLE_SPEED
    elseif love.keyboard.isDown('right') then
        self.dx = PADDLE_SPEED
    else
        self.dx = 0
    end

    -- moving the paddle
    if self.dx < 0 then
        self.x = math.max(0, self.x + self.dx * dt)
    
    else
        self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
    end

end

-- rendering the paddle on the screen

function Paddle:render()
    love.graphics.draw(gTextures['main'], gFrames['paddles'][self.size + 4 * (self.skin - 1)], self.x, self.y)
end