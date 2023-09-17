Ball = Class{}

function Ball:init(skin)
    -- defining size of the balls
    self.width = 8
    self.height = 8

    -- track velocity of the ball into different directions
    self.dx = 0
    self.dy = 0

    -- change the color of the ball
    self.skin = skin
end

-- detect collision with the walls, bricks or paddle

function Ball:collides(target)
    -- check the right edge
    if self.x > target.x + target.width or target.x > self.x + self.width then 
        return false
    end

    -- check the left edge
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end

    -- if there is no collision then return true
    return true
end


-- reset the ball's position
function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.dx = 0
    self.dy = 0
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    -- bouncing of the wall
    if self.x <= 0 then 
        self.x = 0
        self.dx = -self.dx
        gSounds['wall-hit']:play()
    end
    
    if self.x >= VIRTUAL_WIDTH - 8 then
        self.x = VIRTUAL_WIDTH - 8
        self.dx = -self.dx
        gSounds['wall-hit']:play()
    end

    if self.y <= 0 then
        self.y = 0
        self.dy = -self.dy
        gSounds['wall-hit']:play()
    end
end

-- render the ball in the screen
function Ball:render()
    love.graphics.draw(gTextures['main'], gFrames['balls'][self.skin], self.x, self.y)
end
