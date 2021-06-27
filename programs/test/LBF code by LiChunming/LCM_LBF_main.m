clc;clear all;close all;
case_no=2;

lambda1 = 1.0;
lambda2 = 1.0;
nu = 0.001*255*255;%����Ȩֵ
timestep = .1;%ʱ�䲽��
mu = 1;%���Ʒ��ž��뺯��Ȩֵ
epsilon = 1.0;% �����Ծ�ͳ������
sigma=3.0;%��˹�˺���ϵ����Խ�󣬶Գ�ֵ������Խ³�������ָ�Խ����ȷ
K=fspecial('gaussian',round(2*sigma)*2+1,sigma); %��˹�˺���

I = imread(['.\resources\datasets_3\original images\1_34_34288','.jpg']);
I = double(I(:,:,1));
[nrow ncol]=size(I);

switch case_no
	case 1
		phi= sdf2circle(nrow,ncol,95,75,10);%��ʼ��ˮƽ������
		iterNum =11000;
	case 2
		phi= sdf2circle(nrow,ncol,nrow/2,ncol/2,100);%��ʼ��ˮƽ������
		iterNum =1000;
		phi=2*((phi>0)-0.5);
	case 3
		phi= sdf2circle(nrow,ncol,25,55,15);%��ʼ��ˮƽ������
		iterNum =15000;
	case 4
		phi= sdf2circle(nrow,ncol,25,55,15);%��ʼ��ˮƽ������
		iterNum =90;
		phi=2*((phi>0)-0.5);
	case 5
		phi= sdf2circle(nrow,ncol,85,55,15);%��ʼ��ˮƽ������
		iterNum =6100;
	case 6
		phi= sdf2circle(nrow,ncol,85,55,15);%��ʼ��ˮƽ������
		iterNum =50;
		phi=2*((phi>0)-0.5);
end

% figure(1)
% imagesc(I, [0, 255]);colormap(gray);hold on;axis off,axis equal
% [c,h] = contour(phi,[0 0],'r');
% figure;
% mesh(phi);

figure(2)
for n=1:iterNum % �ݻ�ˮƽ������
	phi=LCM_LBF(phi,I,K, nu,timestep,mu,lambda1,lambda2,epsilon);%�ݻ�ˮƽ������
	    if mod(n,10)==0
	        pause(0.1);
	        imagesc(I, [0, 255]);colormap(gray);hold on;axis off,axis equal
	        [c,h] = contour(phi,[0 0],'r');
	        iterNum=[num2str(n), ' iterations'];
	        title(iterNum);
	        hold off;
	    end
end

figure;
mesh(phi);
title('Final level set function');

% ����\phi �ָ�õ��Ķ�ֵͼ����
bwData=zeros(nrow,ncol);
bwData(phi<=0)=1;
bwData = im2bw(bwData);
imagesc(bwData);
colormap(gray);

