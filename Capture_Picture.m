function [cxnum,rynum,colsum,rowsum] = Capture_Picture(IP,PORT,cameraID,angles,pattern_colors)

    SetHeadAngles(IP,PORT,angles);
    GetNaoImage(IP,PORT,cameraID);
    image = cv.LoadImage("temp.jpg");
    imagesize = cv.GetSize(image);   %Returns a value with two elements, the number of columns and the number of rows
    matrix = findColorPattern(image,pattern_colors);
    [colsum,rowsum] = xyProject(matrix,imagesize);
    [cxnum,rynum] = crMax(colsum,rowsum);
    cv.SaveImage("result.jpg",matrix);

end

