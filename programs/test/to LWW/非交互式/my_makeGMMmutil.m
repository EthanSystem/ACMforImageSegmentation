function w= my_makeGMMmutil(A, ncenters)
%w为nrow, ncol, K的矩阵，输出所有像素点的密度
%
%A 为图像,
%ncenters为每个GMM的高斯分支数
% only_name='0_0_284';% 'baboon4';
% 
% img_name = ['./imgs/' only_name '.jpg'];
% 
% A = imread(img_name); 
% ncenters=3;
%  

[nrow,ncol,nbvar]=size(A);

Ainitial=A;

imagedata=double(A);
data=reshape(imagedata(),[],nbvar);
data=data.';


w=zeros(nrow,ncol,ncenters);


A = reshape(A, [], 3)';
A = A;+0.00001*randn(size(A));


n = size(A,2);
stabF = 0.01;

%K-means


    [Unaries, Mu, Sigma] = EM_init_kmeans(data, ncenters);
    [unarypotF, muF, sigmaF] = EM(Ainitial,Unaries, Mu, Sigma);  


    myresult=zeros(length(A),ncenters);%存储样本的密度

    for i=1:ncenters
    myresult(:,i)= unarypotF(i).*gaussPDF(A,muF(:,i),sigmaF(:,:,i));%该结果为nrow*ncol行 1列的myresult(:,i)+
    gauss_result(:,i)=sum(myresult,2);%nrow*ncol行 1列的

end%myresult 的维数为nrow*ncol行 1列的 ncenters的


w(:,:,ncenters)=reshape(gauss_result(:,ncenters),nrow,ncol);%结果

%显示结果
%figure
% subplot(2,1,1); imshow(w(:,:,k));
% subplot(2,1,1);imshow(data_w(:,:,k));

%拉伸尺度，并显示结果
figure
subplot(2,1,1); imshow(w(:,:,ncenters).*255) ;
title(['第',num2str(ncenters),'种GMM模型下整个图像的密度*255']);
%subplot(2,1,2); imshow(data_w(:,:,k).*255);title(['第',num2str(k),'种颜色的用户涂鸦点的密度*255']);

%清0操作

myresult=zeros(size(myresult));
%X_PDF=zeros(nrow*ncol,1);

% %检查结果
% size(find(data_w(:,:,k)>0))



%保存相关的数据
     currentpath=pwd;
     storageName =[pwd '\results\'];
    save ([storageName 'image_PDF'], 'w')
  %  save ([storageName 'data_PDF'] , 'data_w');
end