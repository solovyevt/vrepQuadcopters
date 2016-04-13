package remoteServerVersion;

import coppelia.FloatWA;
import coppelia.IntW;
import coppelia.IntWA;
import coppelia.remoteApi;

/**
 * Created by solov on 16.03.2016.
 */

public class Main {
    public static void main(String[] args) throws InterruptedException {
        System.out.println("Program started");
        remoteApi vrep = new remoteApi();
        vrep.simxFinish(-1); // just in case, close all opned connections
        int clientID = vrep.simxStart("127.0.0.1",19999,true,true,5000,5);
        if (clientID!=-1)
        {
            System.out.println("Connected to remote API server");
            IntW q1Handle = new IntW(0);
            vrep.simxGetObjectHandle(clientID, "Q1", q1Handle, vrep.simx_opmode_blocking);
            System.out.println("Q1 handle: " + q1Handle.getValue());
            FloatWA currentThrusts = new FloatWA(4);
            int result = vrep.simxCallScriptFunction(clientID,"Q1",vrep.sim_scripttype_childscript,"getThrusts",null,null,null,null,null,currentThrusts,null,null,vrep.simx_opmode_blocking);

            for(int i = 0; i < 1000; i++){
                FloatWA newThrusts=new FloatWA(4);
                for(int index = 0; index < 4; index++){
                    newThrusts.getArray()[index] = currentThrusts.getArray()[index] + 0.01f;
                }

                result = vrep.simxCallScriptFunction(clientID,"Q1",vrep.sim_scripttype_childscript,"setThrusts",null,newThrusts,null,null,null,currentThrusts,null,null,vrep.simx_opmode_blocking);
                if (result==vrep.simx_return_ok)
                    System.out.format(String.format("\nCurrent thrusts: %s %s %s %s",
                            currentThrusts.getArray()[0],
                            currentThrusts.getArray()[1],
                            currentThrusts.getArray()[2],
                            currentThrusts.getArray()[3]));
                else
                    System.out.format("Remote function call failed\n");
                Thread.sleep(10);
            }

            vrep.simxFinish(clientID);
        }
        else
            System.out.println("Failed connecting to remote API server");
        System.out.println("Program ended");
    }
}
