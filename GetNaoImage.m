function [] = GetNaoImage(IP,PORT,cameraID)
    camProxy=ALProxy("ALVideoDevice",IP,PORT);
    resolition =2 ;    %VGA格式640*480
    colorSpace = 11;    %RGB

    %select and turn on the camera
    camProxy.setParam(vision_definitions.kCameraSelectID,cameraID);
    videoClient = camProxy.subscribe("python_client",resolition,colorSpace,5);

    %acquire the picture of the camera
    %image [6] Contains image data passed as an array of ASCII characters.
    naoImage = camProxy.getImageRemote(videoClient);

    camProxy.unsubscribe(videoClient);
    %Get image size and pixel array。
    imageWidth=naoImage(1);
    imageHeight=naoImage(2);
    array=naoImage(7);
    %Create a PIL image from our pixel array.
    im = Image.fromstring("RGB",[imageWidth,imageHeight],array);
    %save the image.
    im.save("temp.jpg","JPEG")
end

