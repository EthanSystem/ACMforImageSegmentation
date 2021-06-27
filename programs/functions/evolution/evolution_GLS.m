function [ output_args ] = evolution_GLS( input_args )
%EVOLUTION_GLS 此处显示有关此函数的摘要
%   此处显示详细说明
% This Matlab file demomstrates the general level set (GLS) algorithm;
%Level set formulation: dphi/dt = F|▽phi| ,F= constant c OR curvature κ.  
% Author: Kaihua Zhang, all rights reserved
% E-mail: zhkhua@mail.ustc.edu.cn 
% URL: http://www4.comp.polyu.edu.hk/~cslzhang/
%  Notes:Some parameters may need to be modified for different types of images. Please contact the author if any problem regarding the choice of parameters.
% Date: 17/12/2009



Img = double(imread('1.bmp'));
[row,col]=size(Img);
%--------------------------------
%---The contour is a rectangle.
phi = ones(row,col);
r = 5;
phi(r:row-r,r:col-r) = -1;
%--------------------------------
%---The contour is a circle
% ic = ceil(row/2);jc = ceil(col/2);% circle center
% r  = 10;% radius
% [X,Y] = meshgrid(1:col, 1:row);
% phi = sign(sqrt((X-jc).^2+(Y-ic).^2)-r);
%----------------------------------
imagesc(Img,[0 255]); colormap(gray);hold on;
contour(phi, [0 0], 'r');
title('Initial contour');
hold off;

sigma = .5;
G = fspecial('gaussian', 5, sigma);%Regulalization Gaussian kernel.

delt = 1;% timestep.
Iter = 1000;%Iteration number
F = ones(row,col);%Evolution velocity,contant c OR curvature K.
balloon = 0;%balloon force

imagesc(Img,[0 255]); colormap(gray);hold on;
for n = 1:Iter
    [ux, uy] = gradient(phi);
    absR = sqrt(ux.^2+uy.^2);
   %-------------------------------
   %-- Compute curvature K.
    absR = sqrt(ux.^2+uy.^2);
    absR = absR +(absR==0)*eps;
    [nxx,junk]=gradient(ux./absR);  
    [junk,nyy]=gradient(uy./absR);
    K=nxx+nyy;
    F=K;
    balloon = 0.25;
   %--------------------------------
   %-- Iterate the LS formulation
    phi = phi + delt*(F+balloon).*(absR);
   %---------------------------------
    contour(phi, [0 0], 'w'); 
    iterNum = [num2str(n), 'iterations'];
    title(iterNum);
    pause(0.1)
%   phi = (phi >= 0) - ( phi< 0);% the selective step.
    phi = conv2(phi, G, 'same');
end
  


end

