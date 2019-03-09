function Ig=gauss(I,window,sigma)

%%函数 guass() 实现 guassian 平滑滤波
%%参数说明
%%I         --- 待平滑函数
%%window    --- gaussian 核大小(奇数)
%%simga     --- gaussian 方差
%%Ig        --- 返回 guassian 平滑后的图像

[ny,nx]=size(I);

half_window=(window-1)/2;%方便取中心

if ny<half_window
    x=(-half_window:half_window);
    filter=exp(-x.^2/(2*sigma));%一维 guassian 函数
    filter=filter/sum(filter);%归一化
    %%图像扩展
    xL=mean(I(:,[1:half_window]));
    xR=mean(I(:,[nx-half_window+1,nx]));
    I=[xL*ones(ny,half_window) I xR*ones(ny,half_window)];
        %扩展成 nx + window -1 列
    Ig=conv(I,filter);
        %形成 (nx + window -1) + (window) -1 = nx + 2 (window-1) 列
    Ig=Ig(:,window+half_window+1:nx+window+half_window);
        %第一个卷积要全部用原图像的数据, 从而
        %卷积中第 l 项用的图像数据最小值 = l-windows
        % >=(windows-1)/2+1 = 原图像在扩展图像中的位置
else
    %%二维卷积
    x=ones(window,1)*(-half_window:half_window);%横坐标
    y=x';%纵坐标
    
    filter=exp(-(x.^2+y.^2/(2*sigma)));%二维 guassian 函数
    filter=filter/(sum(sum(filter)));%归一化
    
    %%图像扩展
    if (half_window>1)
        xLeft=mean(I(:,[1:half_window])')';
        %matlab 是对列取平均的，返回行向量
        xRight=mean(I(:,[nx-half_window+1:nx])')';
    else
        xLeft=I(:,1);
        xRight=I(:,nx);
    end
    
    I=[xLeft*ones(1,half_window),I,xRight*ones(1,half_window)];
    
    if (half_window>1)
        xUp=mean(I([1:half_window],:));
        xDown=mean(I([ny-half_window+1,ny],:));
    else
        xUp=I(1,:);
        xDown=I(ny,:);
    end
    
    I=[ones(half_window,1)*xUp;I;ones(half_window,1)*xDown];
    
    Ig=conv2(I,filter,'valid');
    
end