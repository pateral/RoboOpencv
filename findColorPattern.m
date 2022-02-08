    channels = [NaN,NaN,NaN];
    channels(1) = cv.CreateImage(cv.GetSize(img),8,1);
    channels(2) = cv.CreateImage(cv.GetSize(img),8,1);
    channels(3) = cv.CreateImage(cv.GetSize(img),8,1);
    ch1 = cv.CreateImage(cv.GetSize(img),8,1);
    ch2 = cv.CreateImage(cv.GetSize(img),8,1);
    ch3 = cv.CreateImage(cv.GetSize(img),8,1);
    cv.Split(img,ch1,ch2,ch3,None);
    dest = [None,None,None,None];
    dest(1)=cv.CreateImage(cv.GetSize(img),8,1);
    dest(2)=cv.CreateImage(cv.GetSize(img),8,1);
    dest(3)=cv.CreateImage(cv.GetSize(img),8,1);
    dest(4)=cv.CreateImage(cv.GetSize(img),8,1);
    cv.Smooth(ch1,channels(1),cv.CV_GAUSSIAN,3,3,0);
    cv.Smooth(ch2,channels(2),cv.CV_GAUSSIAN,3,3,0);
    cv.Smooth(ch3,channels(3),cv.CV_GAUSSIAN,3,3,0);
    for i = 1:3                     %maybe 0:3
        k=4-i;
        lower=pattern(k)-75;        %Setting thresholds
        upper=pattern(k)+75;
        cv.InRangeS(channels(i),lower,upper,dest(i));
    end
    cv.And(dest(1),dest(2),dest(4));
    temp = cv.CreateImage(cv.GetSize(img),8,1);
    cv.And(dest(2),dest(3),temp);
    %'''
    cv.NameWindow("result",cv.CV_WINDOW_AUTOSIZE)
    cv.ShowImage("result",temp)
    cv.WaitKey(1)
    %'''
   end

