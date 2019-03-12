function [MethodRoberts,MethodLog,MethodSobel] = Methods(pathname,filename)


% im = imread ('.\flower.JPG');
im = imread([pathname,filename]);
img = im(:, :, 1);

tic
disp('Running MethodRoberts');
MethodRoberts = edge(img,'roberts');
    %    size(MethodRoberts)
    %    h1 = [4,0;0,-4];
    %    MethodRoberts = conv2(MethodRoberts,h1);

    % figure
    % imshow(MethodRoberts);
toc

tic
disp('Running MethodLog');
MethodLog = edge(img,'log');
    %    size(MethodLog)
    %    h2 = [0,1,0;1,-4,1;0,1,0];
    %    MethodLog = conv2(MethodLog,h2);

    % figure
    % imshow(MethodLog);
toc

tic
disp('Running MethodSobel');
MethodSobel = edge(img);
    %    size(MethodSobel)
    %    h3 = [1,2,1;0,0,0;-1,-2,-1];
    %    MethodSobel = conv2(MethodSobel,h3);

    % figure
    % imshow(MethodSobel);
toc
end