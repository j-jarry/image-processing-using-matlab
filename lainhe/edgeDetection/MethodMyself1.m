function MyMethod1 = MethodMyself1(pathname,filename)

tic
disp('Running MethodMyself1');
% im = imread ('.\flower.JPG');
im = imread([pathname,filename]);

colorTransform = makecform('srgb2lab');
img = applycform(im, colorTransform);

% figure
% imshow (img);

img = double(img);

[Gx, Gy] = gradient(fspecial('gaussian',[9 9],1));
  
Ix = double(imfilter(img,Gx,'conv', 'circular'));
Iy = double(imfilter(img,Gy,'conv', 'circular'));

IxG = Ix(:, :, 2);
h4 = [1,-1;1,-1];
P1 = conv2(IxG, h4);

% figure
% imshow (P1);

P1bw = im2bw(P1);
P1 = bwareaopen(P1bw,50);

% figure
% imshow (P1);

IyG = Iy(:, :, 2);
h5 = [1,1,;-1,-1];
P2 = conv2(IyG, h5);

% figure
% imshow (P2);

P2bw = im2bw(P2);
P2 = bwareaopen(P2bw,50);

% figure
% imshow (P2);

MyMethod = P1 + P2;
for i3 = 1:1:2
        for i1 = 1:1:3
                MyMethodMed = medfilt2(MyMethod);
                MyMethod = MyMethodMed;
        end
            MyMethodMed = medfilt2(MyMethod,[5 5]);
            MyMethod = MyMethodMed;
end

se = strel('square',5); 
MyMethod1 = imdilate(MyMethod,se);

MyMethod1(:,:,1) = MyMethod1(:,:);
MyMethod1(:,:,2) = 0;
MyMethod1(:,:,3) = 0;

% figure
% imshow (MyMethod1);
toc
end



% -------------------deserted---codes-------------------
%h0 = [1,-1,1;-1,0,-1;1,-1,1];
%redflower2 = gx > 200;
%myflowerA = conv2(redflower2, h0);
%figure
%imshow (myflowerA);
%redflower3 = gy(:, :, 1);
%redflower4 = im2double(redflower3);
%redflower4 = redflower4 > 200;
%h0 = [1,-1,1;-1,0,-1;1,-1,1];
%myflowerB = conv2(redflower4, h0);
%figure
%imshow (myflowerB);

% for i = 1:1:100
%     %myflower4 = medfilt2(myflower3);
%     %eval(['myflower',num2str(i+1),'=','medfilt2(myflower',num2str(i+1),')',';']);
% end

%MyFlower = myflowerA + myflowerB;
%figure
%imshow (MyFlower);

%[row, col] = size(redflower);
%for i = 1:row
%    for j = 1:col
%        if(redflower(i,j) > 200)
%            myflower3(i,j) = redflower (i,j);
%        end
%    end
%end