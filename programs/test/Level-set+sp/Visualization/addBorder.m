function [ imgMarkup ] = addBorder( image, segmentsValue, RGB_color )
%GETBONDER 给图像增加上超像素边界，边界颜色是用户给定的RGB值
%   此处显示详细说明
solution=single(segmentsValue);
[X, Y, Z ]=size(solution);
if X*Y == 1
    [fx,fy]=deal([]);
elseif X == 1
    fx=[];
    fy=gradient(solution);
elseif Y == 1
    fx=gradient(solution);
    fy=[];
else
    [fx,fy]=gradient(solution);
end

xcont=find(fx);
ycont=find(fy);

imgMarkup=image(:,:,1);
imgMarkup(xcont)=RGB_color(1);
imgMarkup(ycont)=RGB_color(1);

if Z==3
    imgTmp2=image(:,:,2);
    imgTmp2(xcont)=RGB_color(2);
    imgTmp2(ycont)=RGB_color(2);
    imgMarkup(:,:,2)=imgTmp2;
    imgTmp3=image(:,:,3);
    imgTmp3(xcont)=RGB_color(3);
    imgTmp3(ycont)=RGB_color(3);
    imgMarkup(:,:,3)=imgTmp3;
end



end

