function [outputArg1,outputArg2] = SetHeadAngles(robotIP,PORT,angles)

    motionProxy = ALProxy("ALMotion",robotIP,PORT);
    motionProxy.setStiffnesses("Head",1.0);

    names = ["HeadPitch","HeadYaw"];
    fractionMaxSpeed = 0.2;
    motionProxy.setAngles(names,angles,fractionMaxSpeed)

    time.sleep(2.0);
    motionProxy.setStiffnesses("Head",0.0);
end

