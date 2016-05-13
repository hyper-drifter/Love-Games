
function love.load()

      love.window.setFullscreen(true)

 starList = {}

 width, height = love.graphics.getDimensions()

 rng = love.math.newRandomGenerator(love.timer.getTime())

 for i = 1, width do
       starList[i]= {}
       for j = 1, height do
             starList[i][j]={}
             if rng:random(1,250) < 1.1 then
                   starList[i][j][1] = true
                   starList[i][j][2] = rng:random(1,1.75)
             else
                   starList[i][j][1] = false
             end
      end
end


end

function love.update(dt)
      if love.keyboard.isDown("escape") then
            love.event.quit(1)
      end
end

function love.draw()


      --draws stars
      for i=1, #starList do
            for j=1, #starList[i] do
                  if starList[i][j][1] == true then
                        love.graphics.setColor(248, 248, 255, 255)
                        love.graphics.circle('fill', i, j, starList[i][j][2])
                  end
            end
      end
      --draws moon
      --love.graphics.setColor(254,252,212)
      --love.graphics.circle('fill', 80, 50, 30, 50)


end
