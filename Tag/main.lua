
function love.load()
      love.window.setFullscreen(true)

      --first the enemy blobs are created with random positions and placed in a list
      enemyList = {}
      rng = love.math.newRandomGenerator(love.timer.getTime())

      blob1 = {x = rng:random(0,love.graphics.getWidth()), y = rng:random(0,love.graphics.getHeight()), speed = 250}
      blob2 = {x = rng:random(0,love.graphics.getWidth()), y = rng:random(0,love.graphics.getHeight()), speed = 250}
      blob3 = {x = rng:random(0,love.graphics.getWidth()), y = rng:random(0,love.graphics.getHeight()), speed = 250}
      blob4 = {x = rng:random(0,love.graphics.getWidth()), y = rng:random(0,love.graphics.getHeight()), speed = 250}
      blob5 = {x = rng:random(0,love.graphics.getWidth()), y = rng:random(0,love.graphics.getHeight()), speed = 250}
      blob6 = {x = rng:random(0,love.graphics.getWidth()), y = rng:random(0,love.graphics.getHeight()), speed = 250}

      table.insert(enemyList,blob1)
      table.insert(enemyList,blob2)
      table.insert(enemyList,blob3)
      table.insert(enemyList,blob4)
      table.insert(enemyList,blob5)
      table.insert(enemyList,blob6)

      --player object is created at center of game region

      player1 = {x = love.graphics.getWidth()/2, y = love.graphics.getHeight()/2, speed = 300, gameover = false, start = false, reset = false}

      --sets boundary for player
      xBound = love.graphics.getWidth()
      yBound = love.graphics.getHeight()

      --variables that keep track of time
      resetTime = 5000000
      timeDelta = 0
end



function love.update(dt)

      --These are the main functions of the game

      --controls enemy movement and ends game when one touches the player
      function enemyControl(enemy)
            local r1p = {}
            r1p.x = player1.x - enemy.x
            r1p.y = player1.y - enemy.y
            if r1p.x > 0 then
                  enemy.x = enemy.x + enemy.speed*dt
            end
            if r1p.x < 0 then
                  enemy.x = enemy.x - enemy.speed*dt
            end
            if r1p.y > 0 then
                  enemy.y = enemy.y + enemy.speed*dt
            end
            if r1p.y < 0 then
                  enemy.y = enemy.y - enemy.speed*dt
            end

            if math.abs(r1p.x) <= 5 and math.abs(r1p.y) <= 5 then
                  player1.gameover = true
            end
      end
      --draws the enemy blobs
      function drawEnemy(enemy)
            love.graphics.setColor(255,0,0)
            love.graphics.circle('fill', enemy.x, enemy.y, 10, 30)
      end
      --resets enemy positions periodically
      function resetEnemyPosition(enemy)
            enemy.x = rng:random(0,love.graphics.getWidth())
            enemy.y = rng:random(0,love.graphics.getHeight())
      end
      --controls player movements while game is running
      function playerControl(player)
            if love.keyboard.isDown("up") then
                  player.y = player.y - player.speed*dt
            end
            if love.keyboard.isDown("down") then
                  player.y = player.y + player.speed*dt
            end
            if love.keyboard.isDown("left") then
                  player.x = player.x - player.speed*dt
            end
            if love.keyboard.isDown("right") then
                  player.x = player.x + player.speed*dt
            end

            if player.x >= xBound then
                  player.x = xBound
            end
            if player.y >= yBound then
                  player.y = yBound
            end
            if player.x <= 0 then
                  player.x = 0
            end
            if player.y <= 0 then
                  player.y = 0
            end
      end
      --controls the reset and start function of the game
      function gameControl (player)
            if love.keyboard.isDown("up") or love.keyboard.isDown("down") or  love.keyboard.isDown("left") or love.keyboard.isDown("right") then --starts game
                  player.start = true
            end
            if love.keyboard.isDown("escape") then --exits game
                  love.event.quit(1)
            end
            if player.reset == true then --allows user to restart after game over
                  if love.keyboard.isDown('space') then
                        player.gameover = false
                        player.start = false
                        player.reset = false
                        for i,v in ipairs(enemyList) do
                              resetEnemyPosition(v)
                        end
                  end
            end

            if player.start == true then --keeps everything moving while the game is on
                  playerControl(player)

                  for i,v in ipairs(enemyList) do
                        enemyControl(v)
                  end

                  timeDelta = timeDelta + love.timer.getTime() --keeps track of when to reset enemies

                  if timeDelta >= resetTime then
                        timeDelta = 0
                        for i,v in ipairs(enemyList) do
                              resetEnemyPosition(v)
                        end
                  end

            end
      end
      --controls when things are drawn
      function drawStuff(player)
            if player.gameover == false then

                  for i,v in ipairs(enemyList) do
                        drawEnemy(v)
                  end

                  love.graphics.setColor(0,0,255)
                  love.graphics.circle('fill', player.x, player.y, 10, 30)
            end

            if player.start == false then
                  love.graphics.setColor(0,0,255,255)
                  love.graphics.print('Move with the arrow keys to start!',love.graphics.getWidth()/2,love.graphics.getHeight()/2-100 )
            end

            if player.gameover == true then
                  love.graphics.print('Game Over!', love.graphics.getWidth()/2-50,love.graphics.getHeight()/2-100)
                  love.graphics.print('Press esc to leave or press the spacebar to continue',love.graphics.getWidth()/2-100,love.graphics.getHeight()/2)
                  player.reset = true
            end
      end


      gameControl(player1)
end



function love.draw(dt)
      love.graphics.setBackgroundColor(125,125,125,125)
      drawStuff(player1)
end
