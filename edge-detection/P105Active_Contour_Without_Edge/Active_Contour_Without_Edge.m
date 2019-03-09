clear all;
close all;
clc;

%Img=imread('brain.bmp');
Img=imread('test.jpg');
Img=double(rgb2gray(Img));
Img=imresize(Img,0.2); % 为了减少程序运行时间，将图像变小为原来大小的 1/2

figure(1);
imshow(uint8(Img));

[ny,nx]=size(Img);%获取图像大小

%%将初始曲线设为圆
%初始圆的圆心
c_i=floor(ny/2);
c_j=floor(nx/2);
%初始圆的半径
r=c_i/3;


%%初始化u为距离函数
u=zeros([ny,nx]);
for i=1:ny
    for j=1:nx
        u(i,j)=r-sqrt((i-c_i).^2+(j-c_j).^2);
    end
end

%%将初始圆形曲线叠加在原始图片上
figure(2);
imshow(uint8(Img));
hold on;
[c,h]=contour(u,[0 0],'r');

%%初始化参数
epsilon=1.0;%Ｈeaviside函数参数设置
mu=250;%弧长的权重
dt=0.1;%时间步长
nn=0;%输出图像个数初始化

%%迭代计算开始
for n=1:1000
    %%计算正则化的Heaviside函数
    H_u=0.5+1/pi.*atan(u/epsilon);
    %%由当前u计算出参数c1,c2
    c1=sum(sum((1-H_u).*Img))/sum(sum(1-H_u));
    c2=sum(sum(H_u.*Img))/sum(sum(H_u));
    %%用当前c1,c2更新u
    delta_epsilon=1/pi*epsilon/(pi^2+epsilon^2);%delta函数的正则化
    m=dt*delta_epsilon;%临时参数m存储时间步长与delta函数的乘积
    %%计算四邻点的权重
    C1=1./sqrt(eps+(u(:,[2:nx,nx])-u).^2+0.25*(u([2:ny,ny],:)-u([1,1:ny-1],:)).^2);
    C2=1./sqrt(eps+(u-u(:,[1,1:nx-1])).^2+0.25*(u([2:ny,ny],[1,1:nx-1])-u([1,1:ny-1],[1,1:nx-1])).^2);
    C3=1./sqrt(eps+(u([2:ny,ny],:)-u).^2+0.25*(u([2:ny,ny],[2:nx,nx])-u([2:ny,ny],[1,1:nx-1])).^2);
    C4=1./sqrt(eps+(u-u([1,1:ny-1],:)).^2+0.25*(u([1,1:ny-1],[2:nx,nx])-u([1,1:ny-1],[1,1:nx-1])).^2);
    C=1+mu*m.*(C1+C2+C3+C4);
    u=(u+m*(mu*(C1.*u(:,[2:nx,nx])+C2.*u(:,[1,1:nx-1])+C3.*u([2:ny,ny],:)+C4.*u([1,1:ny-1],:))+(Img-c1).^2-(Img-c2).^2))./C;
    %%每运行两百次显示曲线和分片常数曲线
    if mod(n,200)==0
        nn=nn+1;
        f=Img;
        f(u>0)=c1;
        f(u<0)=c2;
        figure(nn+2);
        subplot(1,2,1);imshow(uint8(f));
        subplot(1,2,2);imshow(uint8(Img));
        hold on;
        [c,h]=contour(u,[0,0],'r');
        hold off;
    end
end
