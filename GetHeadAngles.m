function [sensorAngles] = GetHeadAngles(robotIP,PORT)
   
    motionProxy = ALProxy("ALMotion",robotIP,PORT);
    names = ["HeadPitch","HeadYaw"];
    useSensors = 1;
    sensorAngles = motionProxy.getAngles(names,useSensors);
  
end

