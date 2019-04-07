I = im2double(imread('cameraman.tif'));

LEN = 21;
THETA = 11;
PSF = fspecial('motion', LEN, THETA);
blurred = imfilter(I, PSF, 'conv', 'circular');
figure, imshow(blurred)
noise_mean = 0;
noise_var = 0.0001;

blurred_noisy = imnoise(blurred, 'gaussian',noise_mean, noise_var);

estimated_nsr = 0;
wnr2 = deconvwnr(blurred_noisy, PSF, estimated_nsr);

estimated_nsr = noise_var / var(I(:));
wnr3 = deconvwnr(blurred_noisy, PSF, estimated_nsr);

subplot(221); imshow(I);
title('Original Image (courtesy of MIT)');
subplot(222); imshow(blurred_noisy);
title('Simulate Blur and Noise');
subplot(223); imshow(wnr2);
title('Restoration of Blurred, Noisy Image Using NSR = 0');
subplot(224); imshow(wnr3);
title('Restoration of Blurred, Noisy Image Using Estimated NSR');