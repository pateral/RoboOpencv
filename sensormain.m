import vision_definitions
% #----------------------单目测距--------------------------------
% #***********************************************
% #@function name：   DistAndDirect_cal(cxnum,rynum,colsum,rowsum,Head_angle,cameraID)
% #@parameters：     (cxnum,rynum)Pixel coordinates of the centre of the sphere obtained by image recognition
% #           (colsum,rowsum)The total scale of the picture：640*480
% #            cameraID=0，use the upper camera；cameraID=1，use the lower camera
% #@return value：   null
% #@function： Using the robot's lower camera to measure the relevant angle and distance of the ball from the robot
def DistAndDirect_cal(cxnum,rynum,colsum,rowsum,Head_angle,cameraID):
    distx=-(cxnum-colsum/2)
    disty=rynum-rowsum/2
    print distx,disty
    Picture_angle=disty*47.64/480

    if cameraID ==0:
        h=0.62
        Camera_angle=12
    else:
        h=0.57
        Camera_angle=38
%     #Head_angle[0] Robot tilt(up and down) angle
    Total_angle=math.pi*(Picture_angle+Camera_angle)/180+Head_angle[0]
    d1=h/math.tan(Total_angle)

    alpha=math.pi*(distx*60.92/640)/180
    d2=d1/math.cos(alpha)
%     #Head_angle[1] Robot left and right angle
    Forward_Distance=d2*math.cos(alpha+Head_angle[1])
    Sideward_Distance=-d2*math.sin(alpha+Head_angle[1])
% #***********************************************
% 
% #@function name：   GetNaoImage(IP,PORT,cameraID)
% #@parameters：     skip
% #@return value：   none
% #@function： The robot's built-in camera control module is called up to capture and hold the current scene.
% #           The robot's forehead camera cannot see the ball as it is approximately less than 0.6m away from the robot，
% #           so we need to switch the camera，cameraID=0，choose the upper one；
% #           cameraID=1，choose the lower one
def GetNaoImage(IP,PORT,cameraID):
    camProxy=ALProxy("ALVideoDevice",IP,PORT);
    resolition =2 ;    %VGA格式640*480
    colorSpace = 11; %RGB

    %select and turn on the camera
    camProxy.setParam(vision_definitions.kCameraSelectID,cameraID);
    videoClient = camProxy.subscribe("python_client",resolition,colorSpace,5);

    %acquire the picture of the camera
    %image [6] Contains image data passed as an array of ASCII characters.
    naoImage = camProxy.getImageRemote(videoClient);

    camProxy.unsubscribe(videoClient);
    %Get image size and pixel array。
    imageWidth=naoImage[0];
    imageHeight=naoImage[1];
    array=naoImage[6];
    %Create a PIL image from our pixel array.
    im = Image.fromstring("RGB",(imageWidth,imageHeight),array);
    %save the image.
    im.save("temp.jpg","JPEG")

% #***********************************************
% #@function name：   findColorPattern(img,pattern)
% #@parameters：     skip
% #@return value：   none
% #@function：  Converting RGB images to binary maps：此方法用的是cv,可以尝试用cv2代码会更加简洁
def  findColorPattern(img,pattern):
    channels=[None,None,None]
    channels[0]=cv.CreateImage(cv.GetSize(img),8,1)
    channels[1]=cv.CreateImage(cv.GetSize(img),8,1)
    channels[2]=cv.CreateImage(cv.GetSize(img),8,1)
    ch0=cv.CreateImage(cv.GetSize(img),8,1)
    ch1=cv.CreateImage(cv.GetSize(img),8,1)
    ch2=cv.CreateImage(cv.GetSize(img),8,1)
    cv.Split(img,ch0,ch1,ch2,None)
    dest=[None,None,None,None]
    dest[0]=cv.CreateImage(cv.GetSize(img),8,1);
    dest[1]=cv.CreateImage(cv.GetSize(img),8,1);
    dest[2]=cv.CreateImage(cv.GetSize(img),8,1);
    dest[3]=cv.CreateImage(cv.GetSize(img),8,1);
    cv.Smooth(ch0,channels[0],cv.CV_GAUSSIAN,3,3,0);
    cv.Smooth(ch1,channels[1],cv.CV_GAUSSIAN,3,3,0);
    cv.Smooth(ch2,channels[2],cv.CV_GAUSSIAN,3,3,0);
    for i in range(3):
        k=2-i
        lower=pattern[k]-75        %Setting thresholds
        upper=pattern[k]+75
        cv.InRangeS(channels[i],lower,upper,dest[i])

    cv.And(dest[0],dest[1],dest[3])
    temp=cv.CreateImage(cv.GetSize(img),8,1)
    cv.And(dest[2],dest[3],temp)
    %'''
    cv.NameWindow("result",cv.CV_WINDOW_AUTOSIZE)
    cv.ShowImage("result",temp)
    cv.WaitKey(0)
    %'''
    return temp

% #***********************************************
% #@function name：   xyProject(matrix,imgaesize)
% #@parameters：     matrix
% #           imgaesize
% #@return value：   none
% #@function： Using a binary map, the pixel coordinates of the ball are calculated. 
%              The principle is: iterate the sum of the pixel values through the rows and columns
% #           ,the largest combination of which is the sphere centre coordinate
def xyProject(matrix,imagesize):
    %Declares a single channel of data type 8-bit imagessize[1]*1/1*imagessize[0]martix(initial value is 0)。
    colmask=cv.CreateMat(imagessize[1],1,cv.CV_8UC1)
    rowmask=cv.CreateMat(1,imagessize[0],cv.CV_8UC1)
    cv.Set(colmask,1)
    cv.Set(rowmask,1)

    colsum=[]
    for i in range(imagesize[0]):
        col=cv.GetCol(matrix,i)
        %Calculating the vector dot product
        a=cv.DotProduct(colmask,col)
        colsum.append(a)

    rowsum=[]
    for i in range(imagesize[1]):
        row=cv.GetRow(matrix,i)
        a=cv.DotProduct(rowmask,row)
        rowsum.append(a)

    return(colsum,rowsum)   %Get the sum of the "1" values in each column

def crMax(colsum,rowsum):
    cx=max(colsum)
    ry=max(rowsum)
    for i in range(len(colsum))
        if colsum[i]==cx
            cxnum=i;
    for i in range(len(rowsum))
        if rowsum[i]==ry
            rynum=i;
    return(cxnum,rynum)
% #***********************************************
% #@function name：  GetHeadAngles(robotIP,PORT)
% #@parameters：    skip
% #@return value：   none
% #@function：
def GetHeadAngles(robotIP,PORT):
    motionProxy=ALProxy("ALMotion",robotIP,PORT)
    names=["HeadPitch","HeadYaw"]
    useSensors=1
    sensorAngles=motionProxy.getAngles(names,useSensors)
    return sensorAngles
% #***********************************************
% #@function name：  SetHeadAngles(robotIP,PORT,angles)
% #@parameters：    skip
% #@return value：   none
% #@function：
def SetHeadAngles(robotIP,PORT,angles):
    motionProxy=ALProxy("ALMotion",robotIP,PORT)
    motionProxy.setStiffnesses("Head",1.0)

    names=["HeadPitch","HeadYaw"]
    fractionMaxSpeed=0.2
    motionProxy.setAngles(names,angles,fractionMaxSpeed)

    time.sleep(2.0)
    motionProxy.setStiffnesses("Head",0.0)

% #***********************************************
% #@function name：   Capture_Picture(IP,PORT,cameraID,angles,pattern_colors)
% #@parameters：     angles
% #           pattern_colors
% #@return value：   none
% #@function： Putting together the series of functions above

def Capture_Picture(IP,PORT,cameraID,angles,pattern_colors):
    SetHeadAngles(IP,PORT,angles)
    GetNaoImage(IP,PORT,cameraID)
    image=cv.LoadImage("temp.jpg")
    imagesize=cv.GetSize(image)   %Returns a value with two elements, the number of columns and the number of rows
    matrix=findColorPattern(image,pattern_colors)
    (colsum,rowsum)=xyProject(matrix,imagesize)
    (cxnum,rynum)=crMax(colsum,rowsum)
    cv.SaveImage("result.jpg",matrix)

    return (cxnum,rynum,colsum,rowsum)

 

% #***********************************************
% #@function name：   Target_Detect_and_Distance(IP,PORT)
% #@parameters：
% #@return value：   none
% #@function： When the upper camera cannot find the ball, switch to the lower camera and turn from right to the left。
% #       During this process, if a target is found, the distance is calculated and output
% #       If the target is never found, the distance is output as 0.

def Target_Detect_and_Distance(IP,PORT):
    pattern_colors=(255,150,50)
    cameraID=0   %# default the upper camera
    angles=[0,0]
    (cxnum,rynum,colsum,rowsum)=Capture_Picture(IP,PORT,cameraID,angles)

    if(cxnum,rynum)==(639,479):
        cameraID=1
        (cxnum,rynum,colsum,rowsum)=Capture_Picture(IP,PORT,cameraID,angles)
    if(cxnum,rynum)==(639,479):
        cameraID=0
        angles=[0.0.7]
        (cxnum,rynum,colsum,rowsum)=Capture_Picture(IP,PORT,cameraID,angles)
    if(cxnum,rynum)==(639,479):
        cameraID=0
        angles=[0,-0.7]
        (cxnum,rynum,colsum,rowsum)=Capture_Picture(IP,PORT,cameraID,angles)
    HeadAngles-GetHeadAngles(IP,PORT)
%     ###############
    (Forward_Distance,Sideward_Distance)=DistAndDirect_cal(cxnum,rynum,colsum,rowsum,Head_angle,cameraID)
    if(cxnum,rynum)==(639,479):
        (Forward_Distance,Sideward_Distance)=(0,0)
    print "Forward_Distance=",Forward_Distance,"meters"
    print "Sideward_Distance="+Sideward_Distance+"meters"

% #***********************************************
% #@function name：   Target_Detect_and_Distance(IP,PORT)
% #@参parameters：
% #@return value：   none
% #@function： When the ball is found, there may be a certain amount of
% error.
% #           So you need to determine which side of the ball is in front of the robot and then which foot to use to kick the ball.

def Final_See(robotIP,PORT):
    pattern_colors=(255,150,50)
    angles=[0.5,0]
    SetHeadAngles(robotIP,PORT,angles)

    cameraID=1

    GetNaoImage(robotIP,PORT,cameraID)
    image=cv.LoadImage("temp.jpg")
    imagesize=cv.GetNaoImage(image)

    matrix=findColorPattern(image,pattern_colors)

    (colsum,rowsum)=xyProject(matrix,imgaesize)
    (cxnum,rynum)=crMax(colsum,rowsum)
    cv.SaveImage("result.jpg",matrix)

    HeadAngles=GetHeadAngles(robotIP,PORT)
%     #########################
    (Forward_Distance,Sideward_Distance)=DistAndDirect_cal(cxnum,rynum,colsum,rowsum,Head_angle,cameraID)

    if cxnum<len(colsum)/2
        side=0; %left leg
    else
        side=1; %right leg
    print "side=",side
    print "last distance=",Forward_Distance
    return (side,Forward_Distance)