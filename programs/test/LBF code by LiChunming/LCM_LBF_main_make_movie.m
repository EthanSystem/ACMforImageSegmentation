clc;clear all;close all;
case_no=1;
 
lambda1 = 1.0;
lambda2 = 1.0;
nu = 0.001*255*255;%长度权值
timestep = .1;%时间步长
mu = 1;%控制符号距离函数权值
epsilon = 1.0;% 定义阶跃和冲击函数
sigma=3.0;%高斯核函数系数，越大，对初值化轮廓越鲁棒，但分割越不精确 
K=fspecial('gaussian',round(2*sigma)*2+1,sigma); %高斯核函数
 
I = imread(['4','.bmp']);
I = double(I(:,:,1));
[nrow ncol]=size(I);
 
switch case_no
    case 1
        phi= sdf2circle(nrow,ncol,95,75,10);%初始化水平集函数
        iterNum =11000;
    case 2
        phi= sdf2circle(nrow,ncol,95,75,10);%初始化水平集函数
        iterNum =70;
        phi=2*((phi>0)-0.5);
    case 3
        phi= sdf2circle(nrow,ncol,25,55,15);%初始化水平集函数
        iterNum =10000;
    case 4
         phi= sdf2circle(nrow,ncol,25,55,15);%初始化水平集函数
        iterNum =90;
        phi=2*((phi>0)-0.5);
    case 5
        phi= sdf2circle(nrow,ncol,85,55,15);%初始化水平集函数
        iterNum =6100;
    case 6
        phi= sdf2circle(nrow,ncol,85,55,15);%初始化水平集函数
        iterNum =50;
        phi=2*((phi>0)-0.5);
end
 
 
fig=figure;
set(fig,'DoubleBuffer','on');
set(gca,'xlim',[-80 80],'ylim',[-80 80],'zlim',[-20 20],'NextPlot','replace','Visible','off');
mov = avifile('example.avi');
 
for n=1:iterNum % 演化水平集函数
    phi=LCM_LBF(phi,I,K, nu,timestep,mu,lambda1,lambda2,epsilon);%演化水平集函数
    if mod(n,10)==0
        
        %pause(0.1);
  
%         imagesc(I, [0, 255]);colormap(gray);hold on;axis off,axis equal
%         [c,h] = contour(phi,[0 0],'w', 'LineWidth',2);
        iterNum=['\color{
black
}第', num2str(n), '次迭代'];
         
        
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
