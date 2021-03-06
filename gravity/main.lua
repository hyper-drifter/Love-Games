--[[
     Author: Taylor Grubbs
     Date: Sometime in Spring 2016

     Description: This game is really a 2-D gravity-like simulation that uses basic Euler-method integration to calculate the trajectories of multiple bodies in a fictional solar system. One can easily alter the initial positions and velocities of the objects by changing their initial values in the load function.
     In addition the player can move the 'sun' with the arrow keys.
]]--

function love.load()
      love.window.setMode(1366, 768, {borderless=true})
      background = love.graphics.newImage('starBackground.png')
      xMid = love.graphics.getWidth()/2
      yMid = love.graphics.getHeight()/2

      --Initial parameters of solar system objects
      earth = {m = 10^4, x0 = xMid, y0 = yMid-175, vX=-50, vY=0, trajectory={}}
      mars = {m = 10^4, x0 = xMid+175, y0 = yMid, vX=0, vY= -50, trajectory={}}
      mercury =  {m = 10^4, x0 = xMid-175, y0 = yMid, vX=0, vY= 50, trajectory={}}
      venus = {m = 10^4, x0 = xMid, y0 = yMid+175, vX=50, vY= 0, trajectory={}}

      sun = {m = 10^6, x0 = xMid, y0 = yMid, vX = 0, vY = 0, speed = 100}

      objectList = {mars, sun, mercury, earth, venus}

      table.insert(earth.trajectory, earth.x0) --gives initial points to the trajectory list
      table.insert(earth.trajectory,earth.y0)
      table.insert(mars.trajectory, mars.x0)
      table.insert(mars.trajectory, mars.y0)
      table.insert(mercury.trajectory, mercury.x0)
      table.insert(mercury.trajectory, mercury.y0)
      table.insert(venus.trajectory, venus.x0)
      table.insert(venus.trajectory, venus.y0)

      g = 1
      start = false
end

function love.update(dt)

      function userControls() --allows user to control sun and exit program
            if love.keyboard.isDown('space') then
                  start = true
            end

            --allows user to control the sun
            if love.keyboard.isDown("up") then
                  sun.y0 = sun.y0 - sun.speed*dt
            end
            if love.keyboard.isDown("down") then
                  sun.y0 = sun.y0 + sun.speed*dt
            end
            if love.keyboard.isDown("left") then
                  sun.x0 = sun.x0 - sun.speed*dt
            end
            if love.keyboard.isDown("right") then
                  sun.x0 = sun.x0 + sun.speed*dt
            end
      end

      --calculates gravitational force on an object due to other objects in the sim
      function gravity(planet, objects)
            local forceTotX = 0
            local forceTotY = 0
            local r
            for i,v in ipairs(objects) do
                  if v ~= planet then
                        r = math.sqrt((planet.x0-v.x0)^2+(planet.y0-v.y0)^2)
                        local forceX = -(g*planet.m*v.m)/(r^3)*(planet.x0-v.x0)
                        local forceY = -(g*planet.m*v.m)/(r^3)*(planet.y0-v.y0)
                        forceTotX = forceTotX + forceX
                        forceTotY = forceTotY + forceY
                  end
            end

            planet.vX = forceTotX/planet.m*dt + planet.vX
            planet.x0 = planet.x0 + planet.vX*dt

            planet.vY = forceTotY/planet.m*dt + planet.vY
            planet.y0 = planet.y0 + planet.vY*dt

            table.insert(planet.trajectory,planet.x0)
            table.insert(planet.trajectory,planet.y0)
      end

      --draws trajectory behind planet
      function drawTrajectory(planet)
            love.graphics.line(planet.trajectory)
      end

      userControls()
      --gravity(sun,objectList)
      if start == true then
            gravity(earth, objectList)
            gravity(mars, objectList)
            gravity(mercury, objectList)
            gravity(venus, objectList)
      end
end

function love.draw()
      --draws the stuff
      love.graphics.setColor(255,255,255,255)
      love.graphics.draw(background, 0,0)

      love.graphics.setColor(0,0,255,255)
      love.graphics.circle('fill', earth.x0, earth.y0, 8, 50)

      love.graphics.setColor(255,0,0,255)
      love.graphics.circle('fill', mars.x0, mars.y0, 8, 50)

      love.graphics.setColor(186,85,211,255)
      love.graphics.circle('fill', mercury.x0, mercury.y0, 8, 50)

      love.graphics.setColor(0,255,0,255)
      love.graphics.circle('fill', venus.x0, venus.y0, 8, 50)

      love.graphics.setColor(255,201,1,255)
      love.graphics.circle('fill', sun.x0, sun.y0, 20, 50)

      if start == false then
            love.graphics.print("Press the spacebar to begin", xMid-50, yMid-25)
      else --draws trajectories
            love.graphics.setColor(0,0,255,255)
            drawTrajectory(earth)
            love.graphics.setColor(255,0,0,255)
            drawTrajectory(mars)
            love.graphics.setColor(186,85,211,255)
            drawTrajectory(mercury)
            love.graphics.setColor(0,255,0,255)
            drawTrajectory(venus)
      end

end
