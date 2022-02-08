function [side,Forward_Distance] = Final_See(robotIP,PORT)
    pattern_colors = [255,150,50];
    angles = [0.5,0];
    SetHeadAngles(robotIP,PORT,angles);

    cameraID = 1;

    GetNaoImage(robotIP,PORT,cameraID);
    image = cv.LoadImage("temp.jpg");
    imagesize = cv.GetNaoImage(image);

    matrix = findColorPattern(image,pattern_colors);

    [colsum,rowsum] = xyProject(matrix,imgaesize);
    [cxnum,rynum] = crMax(colsum,rowsum);
    cv.SaveImage("result.jpg",matrix);

    HeadAngles = GetHeadAngles(robotIP,PORT);
%     #########################
    [Forward_Distance,Sideward_Distance] = DistAndDirect_cal(cxnum,rynum,colsum,rowsum,Head_angle,cameraID);

    if cxnum<length(colsum)/2
        side=0; %left leg
    else
        side=1; %right leg
    end
    print ("side=",side);
    print ("last distance=",Forward_Distance);
    

end

