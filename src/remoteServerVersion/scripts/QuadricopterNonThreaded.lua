--function sendFloats(server, data)
--    server:send(simPackFloats(data))
--end
--
--function receiveFloats(server, count)
--    data = server:receive(4*count)
--    return simUnpackFloats(data)
--end
--
--function sendString(server, str)
--    sendFloats(server, {string.len(str)})
--    server:send(str)
--end
function setThrusts(inInts,inFloats,inStrings,inBuffer)
    thrusts[1] = inFloats[1]
    thrusts[2] = inFloats[2]
    thrusts[3] = inFloats[3]
    thrusts[4] = inFloats[4]
    return {},{thrusts[1], thrusts[2], thrusts[3], thrusts[4]},{},''
end

function getThrusts(inInts,inFloats,inStrings,inBuffer)
    return thrusts
end

function scalarTo3D(s, a)
    return {s*a[3], s*a[7], s*a[11]}
end

function rotate(x, y, theta)
    return {math.cos(theta)*x + math.sin(theta)*y, -math.sin(theta)*x + math.cos(theta)*y}
end

threadFunction=function()
    --
    while simGetSimulationState()~=sim_simulation_advancing_abouttostop do


        -- TODO Выпилить, предварительно перенести функции в java-классы

        -- Get Euler angles for IMU
--        orientation = simGetObjectOrientation(base, -1)
--
--        -- Convert Euler angles to pitch, roll, yaw
--        -- See http://en.wikipedia.org/wiki/Flight_dynamics_(fixed-wing_aircraft) for positive/negative orientation
--        alpha = orientation[1]
--        beta = orientation[2]
--        gamma = orientation[3]
--        rollpitch = rotate(alpha, beta, gamma)
--
--
--
--        -- Send core data to server as pitch
--        -- (positive = nose up), roll (positive = right down), yaw (positive = nose right)
--        sendFloats(server, {timestep, -rollpitch[2], rollpitch[1], -gamma})
--
--
--        -- TODO Возможно выпилить
--        -- Do any additional sending to server
--        dofile(PYQUADSIM_HOME..'pyquadsim_client_loop.lua')


        -- TODO Выпилить, ибо вся необходимая инфа будет приходить через api
        -- Receive thrust values from server
--        if thrusts == nil then
--            simStopSimulation()
--        else

            -- Неободимая хуета, обрабатывает новые данные и перенаправляет их на пропеллеры
            -- Set forces and torques for each propeller
            for i = 1, 4, 1 do

                thrust = thrusts[i]

                force = particleCount* particleDensity * thrust * math.pi * math.pow(particleSizes[i],3) / (6*timestep)
                torque = math.pow(-1, i+1)*.002 * thrust

                -- Set float signals to the respective propellers, and propeller respondables
                simSetFloatSignal('Quadricopter_propeller_respondable'..i, propellerRespondableList[i])

                propellerMatrix = simGetObjectMatrix(propellerList[i],-1)

                forces = scalarTo3D(force,  propellerMatrix)
                torques = scalarTo3D(torque, propellerMatrix)

                -- Set force and torque for propeller
                for k = 1, 3, 1 do
                    simSetFloatSignal('force'..i..k,  forces[k])
                    simSetFloatSignal('torque'..i..k, torques[k])
                end
            end
--        end
        --simSwitchThread()
    end
end

-- Put some initialization code here:
simSetThreadSwitchTiming(2) -- Default timing for automatic thread switching



-- ЗАПУСК СЕРВЕРНОГО СКРИПТА, ВЫПИЛИТЬ!
-- TODO ВЫПИЛИТЬ!

--local portNb = simGetInt32Parameter(sim_intparam_server_port_next)
--local portStart = simGetInt32Parameter(sim_intparam_server_port_start)
--local portRange = simGetInt32Parameter(sim_intparam_server_port_range)
--local newPortNb = portNb+1
--if (newPortNb>=portStart+portRange) then
--    newPortNb=portStart
--end
--
--simSetInt32Parameter(sim_intparam_server_port_next,newPortNb)
--simSetThreadAutomaticSwitch(true)
--
--serverResult = simLaunchExecutable(SERVER_EXECUTABLE,portNb,0)
--
---- Attempt to launch the executable server script
--if (serverResult==-1) then
--    simDisplayDialog('Error',
--        'Server '..SERVER_EXECUTABLE..' could not be launched. &&n'..
--                'Please make sure that it exists and is executable. Then stop and restart the simulation.',
--        sim_dlgstyle_message,false, nil,{0.8,0,0,0,0,0},{0.5,0,0,1,1,1})
--    simPauseSimulation()
--end



-- ХУЕТА ДЛЯ ПОДПИСКИ НА ПОРТ, ВЫПИЛИТЬ!
-- TODO DELETE THIS SHIT

-- On success, attempt to connect to server
--while (serverResult ~= -1 and simGetSimulationState()~=sim_simulation_advancing_abouttostop) do
--
--    -- The executable could be launched. Now build a socket and connect to the server:
--    local socket=require("socket")
--    server = socket.tcp()
--    if server:connect('127.0.0.1',portNb) == 1 then
--        break
--    end
--
--end

-- Инициализация частей коптера

thrusts = {5.0, 5.0, 5.0, 5.0}

base = simGetObjectHandle('Quadricopter_base')

propellerList = {}
propellerRespondableList = {}

-- Get the object handles for the propellers and respondables
for i = 1, 4, 1 do
    propellerList[i]=simGetObjectHandle('Quadricopter_propeller'..i)
    propellerRespondableList[i]=simGetObjectHandle('Quadricopter_propeller_respondable'..i)

end




-- Инициализация параметров коптера


-- Get the particle behavior needed to compute force and torque for each propeller
particleCountPerSecond = 430 --simGetScriptSimulationParameter(sim_handle_self,'particleCountPerSecond')
particleDensity = 8500 --simGetScriptSimulationParameter(sim_handle_self,'particleDensity')

baseParticleSize = 1 --simGetScriptSimulationParameter(sim_handle_self,'particleSize')
timestep = simGetSimulationTimeStep()

-- Compute particle sizes
particleSizes = {}


for i = 1, 4, 1 do

    propellerSizeFactor = simGetObjectSizeFactor(propellerList[i])
    particleSizes[i] = baseParticleSize*0.005*propellerSizeFactor
end

particleCount = math.floor(particleCountPerSecond * timestep)


-- TODO DELETE THIS SHIT
-- Send initialization data to server

--sendString(server, PYQUADSIM_HOME)

-- Запуск стороннего скрипта, скорее всего выпилить

-- Do any additional initialization
--dofile(PYQUADSIM_HOME..'pyquadsim_client_init.lua')




-- ЗАПУСК ПОТОКА



-- Here we execute the regular thread code:
res,err=xpcall(threadFunction,function(err) return debug.traceback(err) end)
if not res then
    simAddStatusbarMessage('Lua runtime error: '..err)
end

-- Put some clean-up code here:
