function [Forward_Distance,Sideward_Distance] = DistAndDirect_cal(cxnum,rynum,colsum,rowsum,Head_angle,cameraID)
    distx=-(cxnum-colsum/2);
    disty=rynum-rowsum/2;
    disp(distx,disty);
    Picture_angle = disty*47.64/480;
    if cameraID ==0
        h = 0.62;
        Camera_angle = 12;
    else
        h = 0.57;
        Camera_angle = 38;
    end
    Total_angle = pi*(Picture_angle+Camera_angle)/180+Head_angle(1);
    d1 = h/tan(Total_angle);
    alpha = pi*(distx*60.92/640)/180;
    d2 = d1/cos(alpha);
    Forward_Distance=d2*cos(alpha+Head_angle(2));
    Sideward_Distance=-d2*sin(alpha+Head_angle(2));
end

