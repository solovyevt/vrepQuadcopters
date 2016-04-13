displayText_function=function(inInts,inFloats,inStrings,inBuffer)
    -- Simply display a dialog box that prints the text stored in inStrings[1]:
    if #inStrings>=1 then
        simDisplayDialog('Message from the remote API client',inStrings[1],sim_dlgstyle_ok,false)
        return {},{},{'message was displayed'},'' -- return a string
    end
end

createDummy_function=function(inInts,inFloats,inStrings,inBuffer)
    -- Create a dummy object with specific name and coordinates
    if #inStrings>=1 and #inFloats>=3 then
        -- local color = {255, 0, 0, 255, 0, 0, 255, 0, 0, 0, 0, 0}
        local dummyHandle=simCreateDummy(0.05, color)
        local position={inInts[2],inInts[3],inInts[4]}
        local errorReportMode=simGetInt32Parameter(sim_intparam_error_report_mode)
        simSetInt32Parameter(sim_intparam_error_report_mode,0) -- temporarily suppress error output (because we are not allowed to have two times the same object name)
        simSetObjectName(dummyHandle,inStrings[1])
        simSetInt32Parameter(sim_intparam_error_report_mode,errorReportMode) -- restore the original error report mode
        simSetObjectPosition(dummyHandle,-1,inFloats)
        return {dummyHandle},{},{},'' -- return the handle of the created dummy
    end
end

if (sim_call_type==sim_childscriptcall_initialization) then
    simExtRemoteApiStart(19997)
end
