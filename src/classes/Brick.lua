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
    gSounds['brick-hit-2']:stop()
    gSounds['brick-hit-2']:play()

    -- if we at a higher tier than go down a tier, if we at the lowest color than change the color
    if self.tier > 0 then
        if self.color == 1 then
            self.tier = self.tier - 1
            self.color = 5
        else
            self.color = self.color - 1
        end

    else
        -- if we are at the first base color then remove the brick from play
        if self.color == 1 then
            self.inPlay = false
        else
            self.color = self.color - 1
        end
    end

    -- play a second layer sound if they are destroyed
    if not self.inPlay then
        gSounds['brick-hit-1']:stop()
        gSounds['brick-hit-1']:play()
    end
end

-- rendering the brick
function Brick:render()
    if self.inPlay then
        love.graphics.draw(gTextures['main'], 
            gFrames['bricks'][1 + ((self.color -1) * 4) + self.tier], 
            self.x, self.y)
    end
end
