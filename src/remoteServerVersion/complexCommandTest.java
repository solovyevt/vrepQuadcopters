package remoteServerVersion;// Copyright 2006-2016 Coppelia Robotics GmbH. All rights reserved.
// marc@coppeliarobotics.com
// www.coppeliarobotics.com
// 
// -------------------------------------------------------------------
// THIS FILE IS DISTRIBUTED "AS IS", WITHOUT ANY EXPRESS OR IMPLIED
// WARRANTY. THE USER WILL USE IT AT HIS/HER OWN RISK. THE ORIGINAL
// AUTHORS AND COPPELIA ROBOTICS GMBH WILL NOT BE LIABLE FOR DATA LOSS,
// DAMAGES, LOSS OF PROFITS OR ANY OTHER KIND OF LOSS WHILE USING OR
// MISUSING THIS SOFTWARE.
// 
// You are free to use/modify/distribute this file for whatever purpose!
// -------------------------------------------------------------------
//
// This file was automatically created for V-REP release V3.3.0 on February 19th 2016

// This example illustrates how to execute complex commands from
// a remote API client. You can also use a similar construct for
// commands that are not directly supported by the remote API.
//
// Load the demo scene 'remoteApiCommandServerExample.ttt' in V-REP, then 
// start the simulation and run this program.
//
// IMPORTANT: for each successful call to simxStart, there
// should be a corresponding call to simxFinish at the end!

import coppelia.*;

public class complexCommandTest
{
    public static void main(String[] args)
    {
        System.out.println("Program started");
        remoteApi vrep = new remoteApi();
        vrep.simxFinish(-1); // just in case, close all opned connections
        int clientID = vrep.simxStart("127.0.0.1",19999,true,true,5000,5);
        if (clientID!=-1)
        {
            System.out.println("Connected to remote API server");
            IntW quadcopter1Handle = new IntW(0);
            vrep.simxGetObjectHandle(clientID, "Quadricopter", quadcopter1Handle, vrep.simx_opmode_blocking);
            System.out.println("Quadcopter1 handle: " + quadcopter1Handle.getValue());

            IntW quadcopter2Handle = new IntW(0);
            vrep.simxGetObjectHandle(clientID, "Quadricopter#0", quadcopter2Handle, vrep.simx_opmode_blocking);
            System.out.println("Quadcopter2 handle: " + quadcopter2Handle.getValue());

            IntW target1handle = new IntW(0);
            vrep.simxGetObjectHandle(clientID, "Quadricopter_target", target1handle, vrep.simx_opmode_blocking);
            System.out.println("Target1 handle: " + target1handle.getValue());

            IntW target2handle = new IntW(0);
            vrep.simxGetObjectHandle(clientID, "Quadricopter_target#0", target2handle, vrep.simx_opmode_blocking);
            System.out.println("Target1 handle: " + target2handle.getValue());





            FloatWA quadcopter2Position = new FloatWA(0);
            FloatWA quadcopterOrientation = new FloatWA(0);

            vrep.simxGetObjectPosition(clientID, quadcopter2Handle.getValue(), -1, quadcopter2Position, vrep.simx_opmode_blocking);
            //System.out.println("Quadcopter position: " + quadcopterPosition.getArray().toString());


            FloatWA target1Position = new FloatWA(0);
            vrep.simxGetObjectPosition(clientID, target2handle.getValue(), -1, target1Position, vrep.simx_opmode_blocking);
            System.out.println("Target position: " + target1Position.getArray()[0]
                    + " " + target1Position.getArray()[1]
                    + " " + target1Position.getArray()[2]);

            IntW cylinderHandle = new IntW(0);
            FloatWA newTargetPosition = new FloatWA(0);
            vrep.simxGetObjectHandle(clientID, "Cylinder", cylinderHandle, vrep.simx_opmode_blocking);

            for(int i = 0; i < 100; i++){
                vrep.simxGetObjectPosition(clientID, cylinderHandle.getValue(), -1, newTargetPosition, vrep.simx_opmode_blocking);
                vrep.simxSetObjectPosition(clientID, target1handle.getValue(), -1, newTargetPosition, vrep.simx_opmode_blocking);
                vrep.simxSetObjectPosition(clientID, target2handle.getValue(), -1, newTargetPosition, vrep.simx_opmode_blocking);
            }


            //int result=vrep.simxCallScriptFunction(clientID,"Quadricopter",vrep.sim_scripttype_childscript,"followPath",null,null,null,null,null,null,null,null,vrep.simx_opmode_blocking);
//
//            // 1. First send a command to display a specific message in a dialog box:
//            StringWA inStrings=new StringWA(1);
//            inStrings.getArray()[0]="Hello world!";
//            StringWA outStrings=new StringWA(0);
//            int result=vrep.simxCallScriptFunction(clientID,"remoteApiCommandServer",vrep.sim_scripttype_childscript,"displayText_function",null,null,inStrings,null,null,null,outStrings,null,vrep.simx_opmode_blocking);
//            if (result==vrep.simx_return_ok)
//                System.out.format("Returned message: %s\n",outStrings.getArray()[0]); // display the reply from V-REP (in this case, just a string)
//            else
//                System.out.format("Remote function call failed\n");
//
//            // 2. Now create a dummy object at coordinate 0.1,0.2,0.3 with name 'MyDummyName':
//            FloatWA inFloats=new FloatWA(3);
//            inFloats.getArray()[0]=0.1f;
//            inFloats.getArray()[1]=0.2f;
//            inStrings=new StringWA(1);
//            inFloats.getArray()[2]=0.3f;
//
//            inStrings.getArray()[0]="MyDummyName";
//            IntWA outInts=new IntWA(0);
//            result=vrep.simxCallScriptFunction(clientID,"remoteApiCommandServer",vrep.sim_scripttype_childscript,"createDummy_function",null,inFloats,inStrings,null,outInts,null,null,null,vrep.simx_opmode_blocking);
//            if (result==vrep.simx_return_ok)
//                System.out.format("Dummy handle: %d\n",outInts.getArray()[0]); // display the reply from V-REP (in this case, the handle of the created dummy)
//            else
//                System.out.format("Remote function call failed\n");

            // Now close the connection to V-REP:
            vrep.simxFinish(clientID);
        }
        else
            System.out.println("Failed connecting to remote API server");
        System.out.println("Program ended");
    }
}
