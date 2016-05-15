function love.load()
      love.window.setFullscreen(true)
      background = love.graphics.newImage('starBackground.png')
      xMid = love.graphics.getWidth()/2
      yMid = love.graphics.getHeight()/2
      rng = love.math.newRandomGenerator(love.timer.getTime())
      numberOfObjects = 50 --change this number to start with more or less objects

      function createInitialObjects(numOfObjs)
            local objects = {}

            for i=1, numOfObjs do
                  local newPlanet = {m = 10^4, x0 = rng:random(0,love.graphics.getWidth()), y0 = rng:random(0,love.graphics.getHeight()), vX = rng:random(-40,40), vY = rng:random(-40,40)}
                  table.insert(objects, newPlanet)
            end

            sun = {m = 10^6, x0 = xMid, y0 = yMid, vX = 0, vY = 0, speed = 100}
            table.insert(objects,sun)
            return objects
      end

      objectList = createInitialObjects(numberOfObjects)

      g = 1
end

function love.update(dt)

      function userControls() --allows user to control sun and exit program
            if love.keyboard.isDown('escape') then
                  love.event.quit(1)
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
      end

      userControls()
      --gravity(sun,objectList)
      for i,v in ipairs(objectList) do
            if v ~= sun then
                  gravity(v, objectList)
            end
      end

end

function love.draw()
      love.graphics.setColor(255,255,255,255)
      love.graphics.draw(background, 0,0)

      love.graphics.setColor(0,0,255,255)
      for i,v in ipairs(objectList) do
            love.graphics.circle('fill', v.x0, v.y0, 8, 50)
      end

      love.graphics.setColor(255,201,1,255)
      love.graphics.circle('fill', sun.x0, sun.y0, 20, 50)
end
