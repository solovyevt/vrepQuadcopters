visualizePath=function(path)
    if not _lineContainer then
        _lineContainer=simAddDrawingObject(sim_drawing_lines,3,0,-1,99999,{0.2,0.2,0.2})
    end
    simAddDrawingObjectItem(_lineContainer,nil)
    if path then
        local pc=#path/3
        for i=1,pc-1,1 do
            lineDat={path[(i-1)*3+1],path[(i-1)*3+2],initPos[3],path[i*3+1],path[i*3+2],initPos[3]}
            simAddDrawingObjectItem(_lineContainer,lineDat)
        end
    end
end


robotHandle=simGetObjectHandle('StartConfiguration')
targetHandle=simGetObjectHandle('GoalConfiguration')
initPos=simGetObjectPosition(robotHandle,-1)
initOrient=simGetObjectOrientation(robotHandle,-1)
t=simExtOMPL_createTask('t')
ss={simExtOMPL_createStateSpace('2d',sim_ompl_statespacetype_pose2d,robotHandle,{-0.5,-0.5},{0.5,0.5},1)}
simExtOMPL_setStateSpace(t,ss)
simExtOMPL_setAlgorithm(t,sim_ompl_algorithm_RRTConnect)
simExtOMPL_setCollisionPairs(t,{simGetObjectHandle('L_start'),sim_handle_all})
startpos=simGetObjectPosition(robotHandle,-1)
startorient=simGetObjectOrientation(robotHandle,-1)
startpose={startpos[1],startpos[2],startorient[3]}
simExtOMPL_setStartState(t,startpose)
goalpos=simGetObjectPosition(targetHandle,-1)
goalorient=simGetObjectOrientation(targetHandle,-1)
goalpose={goalpos[1],goalpos[2],goalorient[3]}
simExtOMPL_setGoalState(t,goalpose)
r,path=simExtOMPL_compute(t,4,-1,800)
while path do
    visualizePath(path)
    -- Simply jump through the path points, no interpolation here:
    for i=1,#path-3,3 do
        pos={path[i],path[i+1],initPos[3]}
        orient={initOrient[1],initOrient[2],path[i+2]}
        simSetObjectPosition(robotHandle,-1,pos)
        simSetObjectOrientation(robotHandle,-1,orient)
        simSwitchThread()
    end
end
