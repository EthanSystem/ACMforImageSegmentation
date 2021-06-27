clc;
clear all;
close all;
 
c0 = 2;
imgID = 'D:\EthanLin\CoreFiles\ProjectsFile\Study\PostGraduate\Projects\ImageSegementation\ACM+GMM\resources\datasets_2\original images\1_34_34288'; % 1,2,3,4,5  % choose one of the five test images
 
Img = imread([num2str(imgID),'.jpg']);
Img = double(Img(:,:,1));
 
switch imgID
    case 1
        iterNum =300;
        lambda1 = 1.0;
        lambda2 = 2.0;
        nu = 0.004*255*255;% coefficient of the length term
        initialLSF = ones(size(Img(:,:,1))).*c0;
        initialLSF(20:70,30:90) = -c0;
    case 2
        iterNum =200;
        lambda1 = 1.0;
        lambda2 = 1.0;
        nu = 0.002*255*255;% coefficient of the length term
        initialLSF = ones(size(Img(:,:,1))).*c0;
        initialLSF(26:32,28:34) = -c0;
    case 3
        iterNum =300;
        lambda1 = 1.0;
        lambda2 = 1.0;
        nu = 0.003*255*255;% coefficient of the length term
        initialLSF = ones(size(Img(:,:,1))).*c0;
        initialLSF(15:78,32:95) = -c0;
    case 4
        iterNum =150;
        lambda1 = 1.0;
        lambda2 = 1.0;
        nu = 0.001*255*255;% coefficient of the length term
        initialLSF = ones(size(Img(:,:,1))).*c0;
        initialLSF(53:77,46:70) = -c0;
    case 5
        iterNum =220;
        lambda1 = 1.0;
        lambda2 = 1.0;
        nu = 0.001*255*255;% coefficient of the length term
        initialLSF = ones(size(Img(:,:,1))).*c0;
        initialLSF(47:60,86:99) = -c0;
end
 
u = initialLSF;
figure;imagesc(Img, [0, 255]);colormap(gray);hold on;axis off,axis equal
title('Initial contour');
[c,h] = contour(u,[0 0],'r');
pause(0.1);
 
timestep = .1;%时间步长
mu = 1;%控制符号距离函数权值
epsilon = 1.0;% 定义阶跃和冲击函数
sigma=3.0;%高斯核函数系数，越大，对初值化轮廓越鲁棒，但分割越不精确 
K=fspecial('gaussian',round(2*sigma)*2+1,sigma); %高斯核函数
I = Img;
 
for n=1:iterNum % 演化水平集函数
    u=LCM_LBF(u,I,K, nu,timestep,mu,lambda1,lambda2,epsilon);
    if mod(n,20)==0
        pause(0.1);
        imagesc(Img, [0, 255]);colormap(gray);hold on;axis off,axis equal
        [c,h] = contour(u,[0 0],'r');
        iterNum=[num2str(n), ' iterations'];
        title(iterNum);
        hold off;
    end
end
imagesc(Img, [0, 255]);colormap(gray);hold on;axis off,axis equal
[c,h] = contour(u,[0 0],'r');
totalIterNum=[num2str(n), ' iterations'];
title(['Final contour, ', totalIterNum]);
 
figure;
mesh(u);
title('Final level set function');

