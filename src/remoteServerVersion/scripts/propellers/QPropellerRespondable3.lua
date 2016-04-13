propellerRespondable = simGetFloatSignal('Quadricopter_propeller_respondable3')

if (sim_call_type==sim_childscriptcall_actuation) then

    force = {0,0,0}
    torque = {0,0,0}

    for i = 1, 3, 1 do
        force[i] = simGetFloatSignal('force3'..i)
        torque[i] = simGetFloatSignal('torque3'..i)
    end

    if propellerRespondable ~= nil then
        simAddForceAndTorque(propellerRespondable,force,torque)
    end

end 