clear ;

close all;

clc;





%% parameters            

only_name='0_0_284';% 'baboon4';

img_name = ['./imgs/' only_name '.jpg'];




scale = 1.0;        % image resize

lambda = 2e-10;     % parameter for unitary

%reset(RandStream.getGlobalStream); % fix the random seed for initalization of GMM


saveProb = 0; % 1: save the probability image



%% main routine

img = imread(img_name); 
img = imresize(img,scale);
[row,col,var]=size(img);

% thresh=graythresh(img);
% img=im2bw(img,thresh);
ncenters=2;%设定每个GMM的高斯分支数，该数目对结果影响很大，对于藏羚羊图片，设定为4所得的结果最好，其它设定会在图像内部出现不比必要的



%从图片中读取涂鸦位置的信息

%[K, labels, idx] = my_seed_generation(ref_name,Scricolor,scale);



st=clock;


%w为所有像素点在所有混合高斯模型中的类条件密度；data_w为所有用户涂鸦的点分别在自己的混合高斯模型中的类条件密度
%由于GMM为连续模型的混合，计算出的密度可能很小，也可能很大

%在这里，实际计算的结果均非常小


w=my_makeGMMmutil(double(img),ncenters);

fprintf('it took %.2f second\n',etime(clock,st));




nlogpxf=log(w(:,:,1));%-log变换，将密度放大，不需要加扰动？因为一个点的密度不为0，log以后不会inf

nlogpxb=log(w(:,:,2));%-log变换，将密度放大






% pfx=nlogpxf./(nlogpxf+nlogpxb);
% 
% pbx=nlogpxb./(nlogpxf+nlogpxb);

%diff_p=pfx-pbx;




%显示结果

% figure
% subplot(2,1,1);
% imagesc(I2);
% colormap(gray);
% title('变换尺度以后的前景类条件密度：pfx');
% %saveas(figure_handle,filename,fileformat);

subplot(2,1,2);
%thresh=graythresh(nlogpxb);
%I2=im2bw(nlogpxb,thresh);
imagesc(nlogpxb);
colormap(gray);
title('变换尺度以后的背景类条件密度：pbx');
