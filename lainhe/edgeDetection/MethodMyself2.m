function MyMethod2 = MethodMyself2 (pathname,filename)

tic
disp('Running MethodMyself2');
% im = imread ('.\flower.JPG');
im = imread([pathname,filename]);

colorTransform = makecform('srgb2lab');
img = applycform(im, colorTransform);

img = double(img);

[Hx, Gy] = gradient(fspecial('gaussian',[9 9],1));

Ix = double(imfilter(img,Hx,'conv', 'circular'));
Iy = double(imfilter(img,Gy,'conv', 'circular'));

IxG = Ix(:, :, 2);
h6 = [1,-1;1,-1];
p1 = conv2(IxG, h6);

% figure
% imshow (p1);

for i3 = 1:1:3
        for i1 = 1:1:3
                p1Med = medfilt2(p1);
                p1 = p1Med;
        end
            p1Med = medfilt2(p1,[5 5]);
            p1 = p1Med;
end

% figure
% imshow (p1);

IxG = Iy(:, :, 2);
h7 = [1,1,;-1,-1];
P2 = conv2(IxG, h7);

% figure
% imshow (P2);

for i3 = 1:1:3
        for i1 = 1:1:3
                P2Med = medfilt2(P2);
                P2 = P2Med;
        end
            P2Med = medfilt2(P2,[5 5]);
            P2 = P2Med;
end

% figure
% imshow (P2);

MyMethod = p1 + P2;
for i3 = 1:1:3
        for i1 = 1:1:3
                MyMethodMed = medfilt2(MyMethod);
                MyMethod = MyMethodMed;
        end
            MyMethodMed = medfilt2(MyMethod,[5 5]);
            MyMethod = MyMethodMed;
end

PSF = fspecial ('gaussian', [5 5], 1);
MyMethod = imfilter (MyMethod, PSF,'conv', 'circular');

MyMethod2(:,:,1) = MyMethod(:,:);
MyMethod2(:,:,2) = 0;
MyMethod2(:,:,3) = 0;

% figure
% imshow (MyMethod2);
toc
end