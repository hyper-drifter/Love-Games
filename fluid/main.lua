--[[
      fluids.lua
      Description: A fluid simulation that uses the Lattice-Boltzmann method where the fi values for each cell are defined as
      7 8 9
      4 5 6
      1 2 3
      yeah, I will explain more later lol
]]--

function love.load()
      love.window.setMode(800, 600)

      width = love.graphics.getWidth()
      height = love.graphics.getHeight()

      unitVector = {{-1,-1}, {0,-1}, {1,-1}, {-1,0}, {0,0}, {1,0}, {-1,1}, {0,1}, {1,1}}
      --weights in vector form
      w = {1/36, 1/9, 1/36, 1/9, 4/9, 1/9, 1/36, 1/9, 1/36}
      cS = 1/math.sqrt(3)

      tau = 1

      --creates fluid density array and initializes all values to the rightward direction, mE
      fluidArray = {}
      for i=1,width do
            fluidArray[i] = {}
            for j=1,height do
                  fluidArray[i][j] = {0, 0, 0, 0, 0, 1, 0, 0, 0}
            end
      end
end

function love.update(dt)

      --gets sum of fluid density cel
      function fSum(fluidArrayCell)
            local sum = 0
            for i,v in ipairs(fluidArrayCell) do
                  sum = sum + v
            end
            return sum
      end

      --gets sum for macroscopic fluid velocity
      function uSum(fluidArrayCell)
            local uVector = {0,0}
            for i,v in ipairs(fluidArrayCell) do
                  uVector[1] = uVector[1] + unitVector[i][1] * v
                  uVector[2] = uVector[2] + unitVector[i][2] * v
            end
            return uVector
      end

      --dot product
      function dotPDT(v1, v2)
            local sum = v1[1]*v2[1] + v1[2] + v2[2]
            return sum
      end

      --calculates new fluid array value from new velocity and density
      function fPrime(fluidArrayCell, fEQ)
            local newF = {}
            for i,v in ipairs(fluidArrayCell) do
                  newF[i] = v - 1/tau * (v - fEQ[i])
            end
            return newF
      end

      --now I loop through the grid and solve for the new fluid densities
      for x,columns in ipairs(fluidArray) do
            for y,cell in ipairs(columns) do

                  --macroscopic density
                  local rho = fSum(cell)
                  --macroscopic fluid velocity
                  local u = (1/rho) * uSum(cell)

                  local fEQ = {}
                  for i=1,9 do
                        fEQ[i] = w[i] * rho * (1 + dotPDT(unitVector[i], u)/cS^2 + dotPDT(unitVector[i], u)^2/(2*cS^4) - dotPDT(u,u)/(2*cS^2))
                  end

                  cell = fPrime(cell, fEQ)

                  fluidArray[x-1][y-1][9] = cell[1]
                  fluidArray[x][y-1][8] = cell[2]
                  fluidArray[x+1][y-1][7] = cell[3]
                  fluidArray[x-1][y][6] = cell[4]
                  fluidArray[x][y][5] = cell[5]
                  fluidArray[x+1][y][4] = cell[6]
                  fluidArray[x-1][y+1][3] = cell[7]
                  fluidArray[x][y+1][2] = cell[8]
                  fluidArray[x+1][y+1][1] = cell[9]

            end
      end
end
