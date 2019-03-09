close all;
clear all;
clc;

%I=imread('Jingse.jpg');
I=imread('test.jpg');

I=imresize(I,0.2);
I=rgb2gray(I);

figure(1);
subplot(1,2,1);imshow(I);title('原图像');
subplot(1,2,2);imhist(I);title('直方图');

J=ones(size(I));
J(I<150)=0;% 不断尝试阈值
figure(2);imshow(J);title('分水岭 (watershed) 算法');
