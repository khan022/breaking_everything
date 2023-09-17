Brick = Class{}

function Brick:init(x, y)
    -- for coloring and score calculation
    self.tier = 0
    self.color = 1

    self.x = x
    self.y = y
    self.width = 32
    self.height = 16

    -- determine wheather to render the bricks or not
    self.inPlay = true
end

-- triggering the hit on brick
function Brick:hit()
    -- sound of hitting the brick
    gSounds['brick-hit-2']:play()

    self.inPlay = false
end

-- rendering the brick
function Brick:render()
    if self.inPlay then
        love.graphics.draw(gTextures['main'], 
            gFrames['bricks'][1 + ((self.color -1) * 4) + self.tier], 
            self.x, self.y)
    end
end
