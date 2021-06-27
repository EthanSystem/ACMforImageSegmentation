function [w,data_w]= my_makeGMMmutil(img, seedsIndex)
% w Ϊ nrow, ncol, K �ľ�������������ص���ܶ�
% data_w Ϊ nrow, ncol, K �ľ������������������ܶ�

[nrow,ncol,nbdata]=size(img);
nSeeds = length(seedsIndex);
w=zeros(nrow,ncol,nSeeds);
data_w=zeros(nrow,ncol,nSeeds);
% data_w=reshape([],nSeeds);




%% 	 ���� GMM_MAP��
% ��ǰ����ѵ������GMM_PDF������������
% �û�����ǰ�������ص���ΪN�������㡣�����㰴��RGB dimension=3��ά������ֱ��ͼ���趨 K����˹������
nbStates=5; % GMM_PDF �ķ�֦��

% ���û����Ƶ�ǰ���ʻ���Ӧ��ԭͼ���е��������ص���ȡ������Ϊǰ��������
load('./results/seeds1.mat');
scale=1.0;
data_img=im2double(img);
data_img=imresize(data_img,scale);
data_img=reshape(data_img,[],3);
data_img=permute(data_img,[2,1]);     % ת�ã�ʹdata����ӦEM������gaussPDF�����ȡ�


data_foreground=zeros(3,size(seedsIndex{1},2));
data_foreground=data_img(:,seedsIndex{1}(:));

% �� �����㼯�� EM �㷨��
% ͨ��k-mean�����ʼ���������� D x N �����ݺ� K ����˹��������EM_init_kmeans���������  [Priors, Mu, Sigma]
[Priors0_foreground,Mu0_foreground,Sigma0_foreground]=EM_init_kmeans(data_foreground,nbStates, 100);

% �� [Priors, Mu, Sigma] ����EM�������� ���յ�  [Priors, Mu, Sigma] ��
[Priors_foreground, Mu_foreground, Sigma_foreground, Pix_foreground] = EM(data_foreground, Priors0_foreground, Mu0_foreground, Sigma0_foreground);
% ����ǰ����ѵ������GMM_PDF
for i=1:nbStates
    Pxi_foreground(:,i)=gaussPDF(data_foreground, Mu_foreground(:,i), Sigma_foreground(:,:,i));
end
GMM_PDF_foreground=Pxi_foreground*Priors_foreground';

% ��ǰ���������������
data_temp=zeros(1,nrow*ncol);
data_temp(seedsIndex{1}(:))=GMM_PDF_foreground;
data_w(:,:,1)=reshape(data_temp,nrow,ncol);



% ͬ����������ѵ������GMM_PDF�����������ݣ�
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



% ���������� ǰ��GMM_PDF �� ����GMM_PDF ��������ͼ��������������ݵ㣬���������� 

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







%% ������ص�����
currentpath=pwd;
storageName =[pwd '\results\'];
save ([storageName 'image_PDF'], 'w')
save ([storageName 'data_PDF'] , 'data_w');
end
