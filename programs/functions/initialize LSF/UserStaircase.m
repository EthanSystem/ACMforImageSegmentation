function [ phi ] = UserStaircase( contourPath, contoursInitValue )
%UserStaircase 用户自定义的轮廓的初始化，初始化形状为阶梯型。
%   input: 
%       contourPath：用户定义的轮廓二值图文件所在的完整路径。
%       contoursInitValue：轮廓初始值。即将这个值用在二值图上，假如值=3，则初始嵌入函数的前景值=-3，背景值=3
%   output: 
%       phi：初始化之后的嵌入函数。
%  
%   created on 04/26/2004
%   author: Chunming Li
%   email: li_chunming@hotmail.com
%   Copyright (c) 2004-2006 by Chunming Li
phi=imread(contourPath);
phi=1.*im2double(phi);
% phi(:,:,[2 3])=[];
phi(phi>=0.5)=+contoursInitValue;
phi(phi<=0.5)=-contoursInitValue;
phi=-phi; % 正负反转
end

