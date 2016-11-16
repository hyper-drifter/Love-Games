--[[
      Author: Taylor Grubbs
      Description: Not sure yet
]]--

function love.load()

      love.window.setMode(800, 600)
      xMid = love.graphics.getWidth()/2
      yMid = love.graphics.getHeight()/2

      rng = love.math.newRandomGenerator(love.timer.getTime())

      player = {x0 = xMid, y0 = yMid, size = 50, v = 300}

      particleNum = 1000

end

function love.update(dt)

      if love.keyboard.isDown("up") then
            player.y0 = player.y0 - player.v*dt
      end
      if love.keyboard.isDown("down") then
            player.y0 = player.y0 + player.v*dt
      end
      if love.keyboard.isDown("left") then
            player.x0 = player.x0 - player.v*dt
      end
      if love.keyboard.isDown("right") then
            player.x0 = player.x0 + player.v*dt
      end
      if love.keyboard.isDown("escape") then
            love.event.quit(0)
      end

end

function love.draw()
      love.graphics.setBackgroundColor(255, 255, 255, 255)

      --draws particles around orb
      love.graphics.setPointSize(2)
      for i=1,particleNum do
            local r = rng:random(1,player.size)
            local theta = rng:random(0,360)
            local x = r * math.cos(math.rad(theta))
            local y = r * math.sin(math.rad(theta))
            love.graphics.setColor(255/r*5,0,255,255)
            love.graphics.points(x+player.x0, y+player.y0)
      end

end
