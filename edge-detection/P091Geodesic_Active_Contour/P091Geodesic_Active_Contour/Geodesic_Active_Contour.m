clear all;
close all;
clc;

N=2000; % 迭代次数设置
D=50; % 每 D 次输出图像，并重新对 U 初始化
dt=0.01; % 时间步长
c=3; % 曲率运动项
K=5; % 反差常数


%% 读入图像
%I=imread('BanShou.bmp');
I=imread('test.jpg');
I=double(rgb2gray(I));
I=imresize(I,0.2); % 为了减少程序运行时间，将图像变小为原来大小的 1/2
figure(1);imshow(uint8(I));title('原始图像');
[ny,nx]=size(I);

%% 设置初始曲线为圆形，圆心为 ci,cj, 半径为 r
ci=ny/2;
cj=nx/2;
%r=ci-1;
r=cj-1;

%% 初始化距离函数
U=zeros([ny,nx]);
for i=1:ny
    for j=1:nx
        U(i,j)=sqrt((i-ci).^2+(j-cj).^2)-r;
    end
end

%% 将初始圆形曲线叠加在原始图像上
figure(2);imshow(uint8(I));
hold on;
[d,h]=contour(U,[0 0],'r');
hold off;

%% 预平滑处理
J=gauss(I,3,2);
%% 图像梯度
Jx=(J(:,[2:end,end])-J(:,[1,1:end-1]))/2;
Jy=(J([2:end,end],:)-J([1,1:end-1],:))/2;
gradient=sqrt(Jx.^2+Jy.^2);
    
for n=1:N
    %% 边缘函数
    g=1./(1+(gradient/K).^2);
    
    %% 向前向后差分
    Ux_back=U-U(:,[1,1:end-1]);
    Ux_forward=U(:,[2:end,end])-U;
    Uy_back=U-U([1,1:end-1],:);
    Uy_forward=U([2:end,end],:)-U;

    %% 计算曲率运动项
    curv=c*g.*sqrt(min(Ux_back,0).^2+max(Ux_forward,0).^2+...
                    min(Uy_back,0).^2+max(Uy_forward,0).^2);
               
    %% 计算散度项
    divg=...
        (g+g(:,[2:end,end]))/2.*...
        Ux_forward./sqrt(Ux_forward.^2+...
            ((U([2:end,end],[2:end,end])+U([2:end,end],:))-...
            (U([1,1:end-1],[2:end,end])+U([1,1:end-1],:))).^2/16+eps)-...
        (g+g(:,[1,1:end-1]))/2.*...
        Ux_back./sqrt(Ux_back.^2+...
            ((U([2:end,end],:)+U([2:end,end],[1,1:end-1]))-...
            (U([1,1:end-1],:)+U([1,1:end-1],[1,1:end-1]))).^2/16+eps)+...
        ((g+g([2:end,end],:))/2).*...
         Uy_forward./sqrt(Uy_forward.^2+...
         ((U([2:end,end],[2:end,end])+U(:,[2:end,end]))-...
         (U([2:end,end],[1,1:end-1])+U(:,[1,1:end-1]))).^2/16+eps)-...
        ((g+g([1,1:end-1],:))/2).*...
         Uy_back./sqrt(Uy_back.^2+...
         ((U(:,[2:end,end])+U([1,1:end-1],[2:end,end]))-...
        (U(:,[1,1:end-1])+U([1,1:end-1],[1,1:end-1]))).^2/16+eps);
    
    %% 迎风格式
    upwind=max(divg,0).*sqrt(...
                    min(Ux_back,0).^2+max(Ux_forward,0).^2+...
                    min(Uy_back,0).^2+max(Uy_forward,0).^2)+...
           min(divg,0).*sqrt(...
                    max(Ux_back,0).^2+min(Ux_forward,0).^2+...
                    max(Uy_back,0).^2+min(Uy_forward,0).^2);
                  
     %% 更新距离函数
     U=U+dt*(curv+upwind);
     
     %% 显示当前曲线和原图像
     if mod(n,D)==0
        %% 为减少累计误差，对 U 进行重新初始化
        I_new=createimage(J,U);
        figure(3);imshow(uint8(I_new));
        n % 输出当前迭代次数，方便看结束时间
     end
end

