function I_out=createimage(I_in,U)

%%函数 createimage() 实现当前水平集在原图像上的显示
%%参数说明
%%I_in   --- 原始图像
%%U      --- 当前零水平集函数
%%I_out  --- 返回当前零水平集 (红色曲线) 叠加在原图像上的图像

[ny,nx]=size(I_in);
curvindex=zeros(5*ny*nx,2); % 存储 U 的零水平集曲线的坐标
curvImg=zeros([ny,nx]);  % 存储 U 在网格点上的颜色标记，红色为 (255，0，0)
num=0; % U 的零水平集曲线的点的个数初始化
for i=2:ny-1
    for j=2:nx-1
        if (U(i,j)<0) & (U(i+1,j)>0 | U(i-1,j)>0 | U(i,j+1)>0 | U(i,j-1)>0) 
            % 从这可以看出 存储 U 的零水平集曲线的坐标个数
            % 最多为 5*ny*nx                    
            num=num+1;
            curvindex(num,1)=i;
            curvindex(num,2)=j;
            curvImg(i,j)=255;
        end
    end
end
            
%% 在原图上显示当前水平集
tmp=I_in;
tmp(curvImg>0)=255;
I_tmp(:,:,1)=tmp;
tmp(curvImg>0)=0;
I_tmp(:,:,2)=tmp;
I_tmp(:,:,3)=tmp;
I_out=uint8(I_tmp);
    
%% 对 U 进行重新初始化为距离函数
U_new=zeros([ny,nx]);
dist=zeros([1,num]);
for i=1:ny
    for j=1:nx
        for k=1:num
            dist(k)=sqrt((i-curvindex(k,1)).^2+(j-curvindex(k,2)).^2);
        end
        U_new(i,j)=min(dist); %% 重新初始化 U 为距离函数
        if U(i,j)<0
            U_new(i,j)=-U_new(i,j); %% 仍然是有向的距离函数
        end
    end
end
U=U_new;