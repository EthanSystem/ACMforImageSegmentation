function [w,data_w]= my_makeGMMmutil(img, seedsIndex)
% w 为 nrow, ncol, K 的矩阵，输出所有像素点的密度
% data_w 为 nrow, ncol, K 的矩阵，输出所有样本点的密度

[nrow,ncol,nbdata]=size(img);
nSeeds = length(seedsIndex);
w=zeros(nrow,ncol,nSeeds);
data_w=zeros(nrow,ncol,nSeeds);
% data_w=reshape([],nSeeds);




%% 	 生成 GMM_MAP：
% 做前景的训练集的GMM_PDF，并保存数据
% 用户画的前景的像素点作为N个样本点。样本点按照RGB dimension=3个维度做成直方图。设定 K个高斯分量。
nbStates=5; % GMM_PDF 的分枝数

% 把用户绘制的前景笔画对应的原图像中的样本像素点提取出来作为前景样本点
load('./results/seeds1.mat');
scale=1.0;
data_img=im2double(img);
data_img=imresize(data_img,scale);
data_img=reshape(data_img,[],3);
data_img=permute(data_img,[2,1]);     % 转置，使data能适应EM函数、gaussPDF函数等。


data_foreground=zeros(3,size(seedsIndex{1},2));
data_foreground=data_img(:,seedsIndex{1}(:));

% 对 样本点集做 EM 算法：
% 通过k-mean聚类初始化参数，把 D x N 的数据和 K 个高斯分量代入EM_init_kmeans函数，输出  [Priors, Mu, Sigma]
[Priors0_foreground,Mu0_foreground,Sigma0_foreground]=EM_init_kmeans(data_foreground,nbStates, 100);

% 把 [Priors, Mu, Sigma] 代入EM函数生成 最终的  [Priors, Mu, Sigma] 。
[Priors_foreground, Mu_foreground, Sigma_foreground, Pix_foreground] = EM(data_foreground, Priors0_foreground, Mu0_foreground, Sigma0_foreground);
% 做出前景的训练集的GMM_PDF
for i=1:nbStates
    Pxi_foreground(:,i)=gaussPDF(data_foreground, Mu_foreground(:,i), Sigma_foreground(:,:,i));
end
GMM_PDF_foreground=Pxi_foreground*Priors_foreground';

% 将前景样本点存入数据
data_temp=zeros(1,nrow*ncol);
data_temp(seedsIndex{1}(:))=GMM_PDF_foreground;
data_w(:,:,1)=reshape(data_temp,nrow,ncol);



% 同理，做背景的训练集的GMM_PDF，并保存数据；
load('./results/seeds2.mat');
data_background=zeros(3,size(seedsIndex{2},2));
data_background=data_img(:,seedsIndex{2}(:));

[Priors0_background,Mu0_background,Sigma0_background]=EM_init_kmeans(data_background,nbStates);
[Priors_background,Mu_background,Sigma_background,Pix_background]=EM(data_background,Priors0_background,Mu0_background,Sigma0_background);

for i=1:nbStates
    Pxi_background(:,i)=gaussPDF(data_background, Mu_background(:,i), Sigma_background(:,:,i));
end
GMM_PDF_background=Pxi_background*Priors_background';

data_temp=zeros(1,nrow*ncol);
data_temp(seedsIndex{2}(:))=GMM_PDF_background;
data_w(:,:,2)=reshape(data_temp,nrow,ncol);



% 接下来，用 前景GMM_PDF 和 背景GMM_PDF 计算整张图像的所有像素数据点，并保存数据 

% [Priors0_img,Mu0_img,Sigma0_img]=EM_init_kmeans(data_img,nbStates,100);
% [Priors_img,Mu_img,Sigma_img,Pix_img]=EM(data_img,Priors0_img,Mu0_img,Sigma0_img);
for i=1:nbStates
    Pxi_img_foreground(:,i)=gaussPDF(data_img, Mu_foreground(:,i), Sigma_foreground(:,:,i));
    Pxi_img_background(:,i)=gaussPDF(data_img, Mu_background(:,i), Sigma_background(:,:,i));
end
GMM_PDF_img_foreground=Pxi_img_foreground*Priors_foreground';
GMM_PDF_img_background=Pxi_img_background*Priors_background';
w(:,:,1)=reshape(GMM_PDF_img_foreground,nrow,ncol);
w(:,:,2)=reshape(GMM_PDF_img_background,nrow,ncol);







%% 保存相关的数据
currentpath=pwd;
storageName =[pwd '\results\'];
save ([storageName 'image_PDF'], 'w')
save ([storageName 'data_PDF'] , 'data_w');
end
