--[[
     Author: Taylor Grubbs 10/8/2016
     Title: diffusion

     Description: This program simulates a fictional gas diffusing from a point in space. The particles do not interact with each other, they don't even obey standard kinematics. On every frame update, each particle randomly picks a direction to move and "steps" in that direction. I've also given each particle random colors so it looks like a bowl of fruity pebbles lol.

     Controls: The user can adjust the particles' speed/kinetic energy by pressing the up and down arrow keys. Press escape to end the simulation.
--]]
function love.load()
     --sets screen resolution and finds screen center
     love.window.setMode(1366, 768, {borderless=true})
     xMid = love.graphics.getWidth()/2
     yMid = love.graphics.getHeight()/2

     --seeds random number generator
     rng = love.math.newRandomGenerator(love.timer.getTime())

     --Creates initial gas distribution
     numberOfObjects = 1000 --change this number to start with more or less objects
     function createInitialObjects(numOfObjs)
          local objects = {}

          for i=1, numOfObjs do
               local newParticle = {x = xMid, y = yMid, r = rng:random(0,255), g = rng:random(0,255), b = rng:random(0,255)}--also sets color parameters
               table.insert(objects, newParticle)
          end

          return objects
     end

     --sets initial particle speed/kinetic energy
     speed = 10

     --sets rate at which user can alter particle energy
     deltaV = 10

     particleList = createInitialObjects(numberOfObjects)

     --controls when to start
     start = false

end



function love.update(dt)
     --Press start to play
     if love.keyboard.isDown('space') then
          start = true
     end

     --user exit function
     if love.keyboard.isDown('escape') then
          love.event.quit(1)
     elseif love.keyboard.isDown('up') then
          speed = speed + deltaV*dt
     elseif love.keyboard.isDown('down') then
          speed = speed - deltaV*dt
     end

     if speed < 0 then --keeps speed from going negative
          speed = 0
     end

     if start == true then
          for i,v in ipairs(particleList) do
               local randXNum = rng:random(-1,1)
               local randYNum = rng:random(-1,1)
               v.x = v.x + randXNum*speed
               v.y = v.y + randYNum*speed
          end
     end
end



function love.draw()
     --draws particles
     for i,v in ipairs(particleList) do
          love.graphics.setColor(v.r,v.g,v.b,255)
          love.graphics.circle('fill', v.x, v.y, 4,50)
     end

     --Tells user how to begin
     if start == false then
          love.graphics.print("Press the spacebar to begin!", xMid-50, yMid-25)
     end
end
