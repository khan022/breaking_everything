Brick = Class{}

-- color for different palletes for particle system 
paletteColors = {
    -- blue
    [1] = {
        ['r'] = 99,
        ['g'] = 155,
        ['b'] = 255
    },
    -- green
    [2] = {
        ['r'] = 106,
        ['g'] = 190,
        ['b'] = 47
    },
    -- red
    [3] = {
        ['r'] = 217,
        ['g'] = 87,
        ['b'] = 99
    },
    -- purple
    [4] = {
        ['r'] = 215,
        ['g'] = 123,
        ['b'] = 186
    },
    -- gold
    [5] = {
        ['r'] = 251,
        ['g'] = 242,
        ['b'] = 54
    }
}

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

    -- apply particle system
    self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 64)
    self.psystem:setParticleLifetime(0.5, 1) -- setting it for 0.5 to 1 second
    self.psystem:setLinearAcceleration(-15, 0, 15, 80) -- drops down the particles
    self.psystem:setEmissionArea('normal', 10, 10) -- deviations in X and Y directions
end

-- triggering the hit on brick
function Brick:hit()
    -- set the particle deploy for two colors. second one shows before fading
    self.psystem:setColors(
        paletteColors[self.color].r / 255,
        paletteColors[self.color].g / 255,
        paletteColors[self.color].b / 255,
        55 * (self.tier + 1) / 255,
        paletteColors[self.color].r / 255,
        paletteColors[self.color].g / 255,
        paletteColors[self.color].b / 255,
        0
    )
    self.psystem:emit(64)

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

-- update the brick with particle system
function Brick:update(dt)
    self.psystem:update(dt)
end

-- rendering the brick
function Brick:render()
    if self.inPlay then
        love.graphics.draw(gTextures['main'], 
            gFrames['bricks'][1 + ((self.color -1) * 4) + self.tier], 
            self.x, self.y)
    end
end

-- rendering the bricks with the particles
function Brick:renderParticles()
    love.graphics.draw(self.psystem, self.x + 16, self.y + 8)
end