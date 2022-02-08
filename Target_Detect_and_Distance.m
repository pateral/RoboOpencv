function [] = Target_Detect_and_Distance(IP,PORT)

    pattern_colors = [255,150,50];
    cameraID = 0  ; %# default the upper camera
    angles = [0,0];
    [cxnum,rynum,colsum,rowsum] = Capture_Picture(IP,PORT,cameraID,angles);

    if isequal([cxnum,rynum],[639,479])
        if cameraID == 1
            [cxnum,rynum,colsum,rowsum]= Capture_Picture(IP,PORT,cameraID,angles);
        %if(cxnum,rynum)==(639,479):
        elseif cameraID == 0
            if isequal(angles,[0,0.7])
                [cxnum,rynum,colsum,rowsum]=Capture_Picture(IP,PORT,cameraID,angles);
        %if(cxnum,rynum)==(639,479):
        %cameraID=0
            elseif isequal(angles,[0,-0.7])
                [cxnum,rynum,colsum,rowsum]=Capture_Picture(IP,PORT,cameraID,angles);
            end
        end
    end

    HeadAngles-GetHeadAngles(IP,PORT);
%     ###############
    [Forward_Distance,Sideward_Distance] = DistAndDirect_cal(cxnum,rynum,colsum,rowsum,Head_angle,cameraID);
    if isequeal([cxnum,rynum],[639,479])
        [Forward_Distance,Sideward_Distance] = [0,0];
    end
    print ("Forward_Distance=",Forward_Distance,"meters");
    print ("Sideward_Distance=",Sideward_Distance,"meters");
end

