WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
local background = love.graphics.newImage("background.png")
local ground = love.graphics.newImage("ground.png")
local BACKGROUND_LOCAL_SPEED = 120
local GROUND_LOCAL_SPEED = 160
local backgroundScroll = 0
local groundScroll = 0
local BACKGROUND_LOOPING_POINT = 1032
local GROUND_LOOPING_POINT = 920
spawnTimer = 0
local lastY = WINDOW_HEIGHT / 2
isScrolling = false
state = "start"

sounds = {
    ["jump"] = love.audio.newSource("Jump.wav", "static"),
    ["hurt"] = love.audio.newSource("Hurt.wav", "static"),
    ["music"] = love.audio.newSource("marios_way.wav", "static")
}

sounds["music"]:setLooping(true)
sounds["music"]:play()  

Class = require "class"
require "Bird"
require "Pipe"
require "PipePair"

local bird = Bird()
local pipePairs = {}

function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {fullscreen = false, resizable = false})
    love.window.setTitle("jumpy bird")
    font = love.graphics.newFont("font.ttf", 32)
    love.graphics.setFont(font)
end

function love.draw()
    love.graphics.draw(background, -backgroundScroll, 0)
    
    for k, pair in pairs(pipePairs) do
        pair:render()
    end
    love.graphics.draw(ground, -groundScroll, WINDOW_HEIGHT - 32)
    
    bird:render()

    if state == "start" then
        love.graphics.printf("Click to start", 0, love.graphics.getHeight() * 3 / 4, love.graphics.getWidth(), "center")
    elseif state == "play" then
        love.graphics.printf(tostring(bird.score), 0, love.graphics.getHeight() * 3 / 4, love.graphics.getWidth(), "center")
    elseif state == "end" then 
        love.graphics.printf("Press R to restart", 0, love.graphics.getHeight() * 3 / 4, love.graphics.getWidth(), "center")
    end
end

function love.update(dt)
    spawnTimer = spawnTimer + dt

    if love.mouse.isDown(1) then
        if state == "start" then
            state = "play"           
        end
    end

    if state == "play" then
        if spawnTimer > 2 then
            local y = math.random(0, 1) == 0 and math.random(lastY + 30, lastY + 80) or math.random(lastY - 80, lastY - 30)
            if y < PIPE_WIDTH then 
                y = lastY + 40
            elseif y > WINDOW_HEIGHT - 120 then
                y = lastY - 40
            end
            table.insert(pipePairs, PipePair(y))
            spawnTimer = 0
        end
    
        for k, pair in pairs(pipePairs) do
            pair:update(dt)

            if not pair.scored then
                if bird.x >= pair.x + PIPE_WIDTH then
                    bird.score = bird.score + 1
                    pair.scored = true
                end
            end
            for l, pipe in pairs(pair.pipes) do
                if bird:collides(pipe, l) then
                    state = "end"
                    sounds["hurt"]:play()
                end
            end
            
            if pair.x < -PIPE_WIDTH then
                pair.remove = true
            end
        end

        for k, pair in pairs(pipePairs) do
            if pair.remove == true then
                table.remove(pipePairs, k)
            end
        end
    

        backgroundScroll = (backgroundScroll + BACKGROUND_LOCAL_SPEED * dt) % BACKGROUND_LOOPING_POINT
        groundScroll = (groundScroll - GROUND_LOCAL_SPEED * dt) % GROUND_LOOPING_POINT
        bird:update(dt)
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    if key == "r" and state == "end" then
        state = "start"
            bird.score = 0
            bird.y = love.graphics.getHeight() / 2
            bird.x = WINDOW_WIDTH / 2 - bird.width / 2
            
            for k, elements in pairs(pipePairs) do
                pipePairs[k] = nil
            end
    end
end