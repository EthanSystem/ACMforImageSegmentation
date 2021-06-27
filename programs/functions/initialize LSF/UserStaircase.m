function [ phi ] = UserStaircase( contourPath, contoursInitValue )
%UserStaircase �û��Զ���������ĳ�ʼ������ʼ����״Ϊ�����͡�
%   input: 
%       contourPath���û������������ֵͼ�ļ����ڵ�����·����
%       contoursInitValue��������ʼֵ���������ֵ���ڶ�ֵͼ�ϣ�����ֵ=3�����ʼǶ�뺯����ǰ��ֵ=-3������ֵ=3
%   output: 
%       phi����ʼ��֮���Ƕ�뺯����
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
phi=-phi; % ������ת
end

