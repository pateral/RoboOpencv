imagesize = [550,366];
pattern = [0,25,50];
img = imread('football.png');
A = findColorPattern(img,pattern);
