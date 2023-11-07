PipePair = Class{}

PIPE_GAP = 200

function PipePair:init(y)
    self.x = WINDOW_WIDTH
    self.y = y

    self.pipes = {
        ["upper"] = Pipe("top", self.y - PIPE_GAP),
        ["lower"] = Pipe("bottom", self.y)
    }
 
    self.remove = false
    self.scored = false
end

function PipePair:update(dt)
    self.x = self.x + PIPE_SPEED * dt
    if self.x > -self.pipes["lower"].width then
        self.pipes["upper"].x = self.x
        self.pipes["lower"].x = self.x
    else
        self.remove = true
    end
end

function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end