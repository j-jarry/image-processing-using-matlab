function Main
clc
close all

% flower = imread ('.\flower.JPG');
[filename,pathname]=uigetfile({'*.jpg;*.bmp;*.tif;*.png;*.gif','All Image Files';'*.*','All Files'});
im = imread([pathname,filename]);

[MethodRoberts,MethodLog,MethodSobel] = Methods(pathname,filename);MyMethod1 = MethodMyself1(pathname,filename);MyMethod2 = MethodMyself2(pathname,filename);

subplot (2,4,1);
    imshow (im,'InitialMagnification','fit');
    title ('original');
    
subplot (2,4,2);
    imshow (MethodRoberts,'InitialMagnification','fit');
    title ('Roberts');
    
subplot (2,4,5);
    imshow (MethodLog,'InitialMagnification','fit');
    title ('Log');
    
subplot (2,4,6);
    imshow (MethodSobel,'InitialMagnification','fit');
    title ('Sobel');
    
subplot (2,4,3:4);
    imshow (MyMethod1,'InitialMagnification','fit');
    title ('My First Method');
    
subplot (2,4,7:8);
    imshow (MyMethod2,'InitialMagnification','fit');
    title ('My Second Method');
end