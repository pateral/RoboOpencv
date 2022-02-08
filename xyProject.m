% #***********************************************
% #@function name：   xyProject(matrix,imgaesize)
% #@parameters：     matrix
% #           imgaesize
% #@return value：   none
% #@function： Using a binary map, the pixel coordinates of the ball are calculated. 
%              The principle is: iterate the sum of the pixel values through the rows and columns
% #           ,the largest combination of which is the sphere centre coordinate
function [colsum,rowsum] = xyProject(matrix,imagesize)
    %Declares a single channel of data type 8-bit imagessize[1]*1/1*imagessize[0]martix(initial value is 0)。
    colmask = cv.CreateMat(imagesize(2),1,cv.CV_8UC1);
    rowmask = cv.CreateMat(1,imagesize(1),cv.CV_8UC1);
    cv.Set(colmask,1);
    cv.Set(rowmask,1);

    colsum = [];
    for i = 1 : imagesize(1)                    %i in range(imagesize(0)):
        col = cv.GetCol(matrix,i);
        %Calculating the vector dot product
        a = cv.DotProduct(colmask,col);
        colsum.append(a);
    end

    rowsum=[];
    for i = 1 : imagesize(2)                    %i in range(imagesize(1)):
        row = cv.GetRow(matrix,i);
        a = cv.DotProduct(rowmask,row);
        rowsum.append(a);
    end
end
