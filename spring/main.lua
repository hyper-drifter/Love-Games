--[[
     Author: Taylor Grubbs
     Date: 10/31/2016 Happy Halloween

     Description: Simulation of 2-D spring-like force on a ball. 
]]--

function love.load()

     love.window.setMode(800, 600)
     xMid = love.graphics.getWidth()/2
     yMid = love.graphics.getHeight()/2
     rng = love.math.newRandomGenerator(love.timer.getTime())

     --init parameters
     ball = {mass = 1, springX = 25, springY = 50, x = 700, y = 550, vX = 100, vY = 100, traj = {}}

     --gives initial values to ball's trajectory
     table.insert(ball.traj, ball.x)
     table.insert(ball.traj, ball.y)

end

function love.update(dt)

     function forceCalc(particle)

          local forceX = -particle.springX*(particle.x-xMid)
          local forceY = -particle.springY*(particle.y-yMid)

          particle.vX = forceX/particle.mass*dt + particle.vX
          particle.vY = forceY/particle.mass*dt + particle.vY

          particle.x = particle.x + particle.vX*dt
          particle.y = particle.y + particle.vY*dt
     end

     forceCalc(ball)
     table.insert(ball.traj, ball.x)
     table.insert(ball.traj, ball.y)

end

function love.draw()

     --draws ball and its trajectory
     love.graphics.setBackgroundColor(255,255,255,255)
     love.graphics.setColor(0,150,255,255)
     love.graphics.circle('fill', ball.x, ball.y, 8, 50)
     love.graphics.line(ball.traj)

     --draws "spring"
     love.graphics.setColor(255,0,0,255)
     love.graphics.setLineStyle('rough')
     love.graphics.line(xMid,yMid, ball.x, ball.y)

end
