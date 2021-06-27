% This Matlab file demomstrates a level set algorithm based on Kaihua Zhang et al's paper:
%    "Active contours driven by local image fitting energy" published by pattern recognition (2009)
% Author: Kaihua Zhang, all rights reserved
% E-mail: zhkhua@mail.ustc.edu.cn
% http://www4.comp.polyu.edu.hk/~cslzhang/
%  Notes:
%   1. Some parameters may need to be modified for different types of images. Please contact the author if any problem regarding the choice of parameters.
%   2. Intial contour should be set properly.

% Date: 3/11/2009

clear all;close all;clc;

Img = imread(['.\data\resources\MSRA1K\original resources\original images\1_37_37446.jpg']);
% Img = double(Img(:,:,1));
Img = double(Img(:,:,1));
sigma =3;% the key parameter which needs to be tuned properly.
sigma_phi = 0.5;% the variance of regularized Gaussian kernel
K = fspecial('gaussian',2*round(2*sigma)+1,sigma);
K_phi = fspecial('gaussian',5,sigma_phi);
[nrow,ncol] = size(Img);

% % staircase
% phi = ones(nrow,ncol);
% r   = 100;
% phi(r:nrow-r,r:ncol-r) = -1;

% % SDF
ic = nrow/2;jc = ncol/2; r = 100;
phi= sdf2circle(nrow,ncol,ic,jc,r);

figure;  imagesc(Img,[0 255]);colormap(gray);hold on;
contour(phi,[0 0],'b');

timestep = 1;
epsilon = 1.5;

for n = 1:100
	
	[phi,f1,f2,Hphi]= LIF_2D(Img,phi,timestep,epsilon,K);
	phi = conv2(phi,K_phi,'same');
	
	if mod(n,100) == 0
		pause(0.0001);
		imagesc(Img,[0 255]);colormap(gray)
		hold on;contour(phi,[0 0],'b');
		iterNum=[num2str(n), ' iterations'];
		title(iterNum);
		hold off;
	end

end

figure;
mesh(phi);

% 生成\phi 分割得到的二值图数据
bwData=zeros(nrow,ncol);
bwData(phi<=0)=1;
bwData = im2bw(bwData);
figure;
imagesc(bwData);
colormap(gray);

