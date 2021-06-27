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
ncenters=2;%�趨ÿ��GMM�ĸ�˹��֧��������Ŀ�Խ��Ӱ��ܴ󣬶��ڲ�����ͼƬ���趨Ϊ4���õĽ����ã������趨����ͼ���ڲ����ֲ��ȱ�Ҫ��



%��ͼƬ�ж�ȡͿѻλ�õ���Ϣ

%[K, labels, idx] = my_seed_generation(ref_name,Scricolor,scale);



st=clock;


%wΪ�������ص������л�ϸ�˹ģ���е��������ܶȣ�data_wΪ�����û�Ϳѻ�ĵ�ֱ����Լ��Ļ�ϸ�˹ģ���е��������ܶ�
%����GMMΪ����ģ�͵Ļ�ϣ���������ܶȿ��ܺ�С��Ҳ���ܴܺ�

%�����ʵ�ʼ���Ľ�����ǳ�С


w=my_makeGMMmutil(double(img),ncenters);

fprintf('it took %.2f second\n',etime(clock,st));




nlogpxf=log(w(:,:,1));%-log�任�����ܶȷŴ󣬲���Ҫ���Ŷ�����Ϊһ������ܶȲ�Ϊ0��log�Ժ󲻻�inf

nlogpxb=log(w(:,:,2));%-log�任�����ܶȷŴ�






% pfx=nlogpxf./(nlogpxf+nlogpxb);
% 
% pbx=nlogpxb./(nlogpxf+nlogpxb);

%diff_p=pfx-pbx;




%��ʾ���

% figure
% subplot(2,1,1);
% imagesc(I2);
% colormap(gray);
% title('�任�߶��Ժ��ǰ���������ܶȣ�pfx');
% %saveas(figure_handle,filename,fileformat);

subplot(2,1,2);
%thresh=graythresh(nlogpxb);
%I2=im2bw(nlogpxb,thresh);
imagesc(nlogpxb);
colormap(gray);
title('�任�߶��Ժ�ı����������ܶȣ�pbx');
