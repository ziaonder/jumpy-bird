Pipe = Class{}

PIPE_SPEED = -200
local PIPE_IMAGE = love.graphics.newImage("pipe.png")
PIPE_WIDTH = 140
PIPE_HEIGHT = 576

function Pipe:init(orientation, y)
    self.width = PIPE_IMAGE:getWidth()
    self.height = PIPE_IMAGE:getHeight()
    self.x = love.graphics.getWidth()
    self.y = y
    self.orientation = orientation
end

function Pipe:render()                   --self.orientation == "top" and self.y - self.height or self.y
    love.graphics.draw(PIPE_IMAGE, self.x, self.y, 0, 1,
    self.orientation == "top" and -1 or 1)
end
