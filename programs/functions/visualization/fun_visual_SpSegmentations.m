function [segOutline, imgMarkup,RGBImgMarkup]=fun_visual_SpSegmentations( img,RGBImg, segmentsValue, SuperPixels,Pros)
%Function [imgMasks,segOutline,imgMarkup]=visual_SpSegmentations(img,solution)
%generates output for a Cartesian image with dimensions X/Y and a solution
%conisiting of integer valued nodes indicating membership in a segment
%
%Inputs: img - Original image
%        solution - A 1xN vector assigning an integer to each node
%           indicating its membership in a segment
%
%Outputs: imgMasks - An image where every pixel is assigned an integer
%           such that pixels sharing numbers belong to the same segment
%         imgMarkup - The same image as the inputs with the red channel
%           set to 1 along the borders of segments
%         segOutline - A white background with black lines indicating the
%           segments borders
%
%
%5/23/03 - Leo Grady

% Copyright (C) 2002, 2003 Leo Grady <lgrady@cns.bu.edu>
%   Computer Vision and Computational Neuroscience Lab
%   Department of Cognitive and Neural Systems
%   Boston University
%   Boston, MA  02215
%
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
%
% Date - $Id: segoutput.m,v 1.3 2003/08/21 17:29:29 lgrady Exp $
%========================================================================%

% parameters
GRAY_edgecolor=0.5;
R_color=0;
G_color=0;
B_color=1;
R_RGBcolor=0;
G_RGBcolor=1;
B_RGBcolor=1;

%Inputs
[X, Y, Z]=size(img);

%Build outputs
% imgMasks=reshape(solution,X,Y);           % delete it because no need

%Outline segments
imgSeg=single(segmentsValue);
if X*Y == 1
    [fx,fy]=deal([]);
elseif X == 1
    fx=[];
    fy=gradient(imgSeg);
elseif Y == 1
    fx=gradient(imgSeg);
    fy=[];
else
    [fx,fy]=gradient(imgSeg);
end
xcont=find(fx);
ycont=find(fy);

segOutline=ones(X,Y);
segOutline(xcont)=GRAY_edgecolor;
segOutline(ycont)=GRAY_edgecolor;


% 给分割边界涂色，附着在给定的颜色空间的图像上

imgMarkup=img(:,:,1);
imgMarkup(xcont)=R_color;
imgMarkup(ycont)=R_color;

if Z == 3
    imgTmp2=img(:,:,2);
    imgTmp2(xcont)=G_color;
    imgTmp2(ycont)=G_color;
    imgMarkup(:,:,2)=imgTmp2;
    imgTmp3=img(:,:,3);
    imgTmp3(xcont)=B_color;
    imgTmp3(ycont)=B_color;
    imgMarkup(:,:,3)=imgTmp3;
    
else
    imgTmp1=img(:,:,1);
    imgTmp1(xcont)=0;
    imgTmp1(ycont)=0;
    imgMarkup(:,:,2)=imgTmp1;
    imgMarkup(:,:,3)=imgTmp1;
end

% 给分割边界涂色，附着在RGB颜色空间的图像上

RGBImgMarkup=RGBImg(:,:,1);
RGBImgMarkup(xcont)=R_RGBcolor;
RGBImgMarkup(ycont)=R_RGBcolor;
RGBImgTmp2=RGBImg(:,:,2);
RGBImgTmp2(xcont)=G_RGBcolor;
RGBImgTmp2(ycont)=G_RGBcolor;
RGBImgMarkup(:,:,2)=RGBImgTmp2;
RGBImgTmp3=RGBImg(:,:,3);
RGBImgTmp3(xcont)=B_RGBcolor;
RGBImgTmp3(ycont)=B_RGBcolor;
RGBImgMarkup(:,:,3)=RGBImgTmp3;

%% Visualization
Pros.handles_figure_segoutput = figure('name','超像素可视化');
subplot(3,1,1);
imshow(segOutline);
title('超像素边界');
for i=1:1:Pros.numSP
    text(SuperPixels(i).centerPointPosition_2,SuperPixels(i).centerPointPosition_1, num2str(i),'FontSize',8); % 显示标号
end
subplot(3,1,2);
imshow(imgMarkup);
title([Pros.colorspace,' 图像中的超像素分布']);
subplot(3,1,3);
imshow(RGBImgMarkup);
title('对应的RGB图像中的超像素分布');


%% save screen shot
Pros.filename_visualize_segoutput = [Pros.filename_originalImage '_segOutput.jpg'];
Pros.filepath_visualize_segoutput = fullfile(Pros.folderpath_screenShot, Pros.filename_visualize_segoutput);
saveas(gcf, Pros.filepath_visualize_segoutput);




