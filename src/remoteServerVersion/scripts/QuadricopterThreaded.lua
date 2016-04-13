-- DO NOT WRITE CODE OUTSIDE OF THE if-then-end SECTIONS BELOW!! (unless the code is a function definition)

function setThrusts(inInts,inFloats,inStrings,inBuffer)
    thrusts[1] = inFloats[1]
    thrusts[2] = inFloats[2]
    thrusts[3] = inFloats[3]
    thrusts[4] = inFloats[4]
    return {},{thrusts[1], thrusts[2], thrusts[3], thrusts[4]},{},''
end

function getThrusts(inInts,inFloats,inStrings,inBuffer)
    return {},{thrusts[1], thrusts[2], thrusts[3], thrusts[4]},{},''
end

function scalarTo3D(s, a)
    return {s*a[3], s*a[7], s*a[11]}
end

function rotate(x, y, theta)
    return {math.cos(theta)*x + math.sin(theta)*y, -math.sin(theta)*x + math.cos(theta)*y}
end

if (sim_call_type==sim_childscriptcall_initialization) then

    -- Put some initialization code here

    -- Make sure you read the section on "Accessing general-type objects programmatically"
    -- For instance, if you wish to retrieve the handle of a scene object, use following instruction:
    --
    -- handle=simGetObjectHandle('sceneObjectName')
    --
    -- Above instruction retrieves the handle of 'sceneObjectName' if this script's name has no '#' in it
    --
    -- If this script's name contains a '#' (e.g. 'someName#4'), then above instruction retrieves the handle of object 'sceneObjectName#4'
    -- This mechanism of handle retrieval is very convenient, since you don't need to adjust any code when a model is duplicated!
    -- So if the script's name (or rather the name of the object associated with this script) is:
    --
    -- 'someName', then the handle of 'sceneObjectName' is retrieved
    -- 'someName#0', then the handle of 'sceneObjectName#0' is retrieved
    -- 'someName#1', then the handle of 'sceneObjectName#1' is retrieved
    -- ...
    --
    -- If you always want to retrieve the same object's handle, no matter what, specify its full name, including a '#':
    --
    -- handle=simGetObjectHandle('sceneObjectName#') always retrieves the handle of object 'sceneObjectName'
    -- handle=simGetObjectHandle('sceneObjectName#0') always retrieves the handle of object 'sceneObjectName#0'
    -- handle=simGetObjectHandle('sceneObjectName#1') always retrieves the handle of object 'sceneObjectName#1'
    -- ...
    --
    -- Refer also to simGetCollisionhandle, simGetDistanceHandle, simGetIkGroupHandle, etc.
    --
    -- Following 2 instructions might also be useful: simGetNameSuffix and simSetNameSuffix

    thrusts = {5.0, 5.0, 5.0, 5.0}

    base = simGetObjectHandle('Quadricopter_base')

    propellerList = {}
    propellerRespondableList = {}

    -- Get the object handles for the propellers and respondables
    for i = 1, 4, 1 do
        propellerList[i]=simGetObjectHandle('Quadricopter_propeller'..i)
        propellerRespondableList[i]=simGetObjectHandle('Quadricopter_propeller_respondable'..i)

    end

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

end


if (sim_call_type==sim_childscriptcall_actuation) then
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
end


if (sim_call_type==sim_childscriptcall_sensing) then

    -- Put your main SENSING code here

end


if (sim_call_type==sim_childscriptcall_cleanup) then

    -- Put some restoration code here

end