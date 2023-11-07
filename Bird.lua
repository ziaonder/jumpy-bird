Bird = Class{}

local gravity = 10
holdDuration = 0
mouseReleased = true

function Bird:init()
    self.image = love.graphics.newImage("bird.png")
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.x = WINDOW_WIDTH / 2 - self.width / 2  --610
    self.y = WINDOW_HEIGHT / 2 - self.height / 2
    self.dy = 0
    self.score = 0
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

function Bird:update(dt)
    self.dy = self.dy + gravity * dt

    if love.mouse.isDown(1) then
        mouseReleased = false
        holdDuration = holdDuration + love.timer.getDelta()
        
        if holdDuration < 0.1 then
            self.dy = -5
            sounds["jump"]:play()
        end
    end

    self.y = self.y + self.dy

    if self.y + self.height > love.graphics.getHeight() - 32 or self.y + self.height < 0 then
        state = "end"
    end
end

function Bird:collides(pipe, position)
    
    if (self.x + 15) + (self.width - 30) >= pipe.x and (self.x + 15) <= pipe.x + PIPE_WIDTH then
        if position == "lower" then
            if (self.y + 15) + (self.height - 30) >= pipe.y and (self.y + 15) <= pipe.y + PIPE_HEIGHT then
                return true
             end
        else
            if (self.y + 15) <= pipe.y and self.y <= pipe.y + PIPE_HEIGHT then
                return true
             end
        end
    end

    return false
end

function love.mousereleased(x, y, button, istouch, presses)
    if button == 1 then
        holdDuration = 0
        mouseReleased = true
    end
end
