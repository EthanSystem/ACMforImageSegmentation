clc;clear all;close all;
case_no=1;
 
lambda1 = 1.0;
lambda2 = 1.0;
nu = 0.001*255*255;%����Ȩֵ
timestep = .1;%ʱ�䲽��
mu = 1;%���Ʒ��ž��뺯��Ȩֵ
epsilon = 1.0;% �����Ծ�ͳ������
sigma=3.0;%��˹�˺���ϵ����Խ�󣬶Գ�ֵ������Խ³�������ָ�Խ����ȷ 
K=fspecial('gaussian',round(2*sigma)*2+1,sigma); %��˹�˺���
 
I = imread(['4','.bmp']);
I = double(I(:,:,1));
[nrow ncol]=size(I);
 
switch case_no
    case 1
        phi= sdf2circle(nrow,ncol,95,75,10);%��ʼ��ˮƽ������
        iterNum =11000;
    case 2
        phi= sdf2circle(nrow,ncol,95,75,10);%��ʼ��ˮƽ������
        iterNum =70;
        phi=2*((phi>0)-0.5);
    case 3
        phi= sdf2circle(nrow,ncol,25,55,15);%��ʼ��ˮƽ������
        iterNum =10000;
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
 
 
fig=figure;
set(fig,'DoubleBuffer','on');
set(gca,'xlim',[-80 80],'ylim',[-80 80],'zlim',[-20 20],'NextPlot','replace','Visible','off');
mov = avifile('example.avi');
 
for n=1:iterNum % �ݻ�ˮƽ������
    phi=LCM_LBF(phi,I,K, nu,timestep,mu,lambda1,lambda2,epsilon);%�ݻ�ˮƽ������
    if mod(n,10)==0
        
        %pause(0.1);
  
%         imagesc(I, [0, 255]);colormap(gray);hold on;axis off,axis equal
%         [c,h] = contour(phi,[0 0],'w', 'LineWidth',2);
        iterNum=['\color{
black
}��', num2str(n), '�ε���'];
         
        
        mesh(phi);
       % set(gca,'ZDir','reverse');
        zlim([-15 110])
        %title(iterNum);
        text(80,10,-18,iterNum);
        hold off;
        F = getframe(gca);
        mov = addframe(mov,F);
 
    end
end
mov = close(mov);
 
figure;
mesh(phi);
title('Final level set function');
