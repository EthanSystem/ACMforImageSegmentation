function w= my_makeGMMmutil(A, ncenters)
%wΪnrow, ncol, K�ľ�������������ص���ܶ�
%
%A Ϊͼ��,
%ncentersΪÿ��GMM�ĸ�˹��֧��
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


    myresult=zeros(length(A),ncenters);%�洢�������ܶ�

    for i=1:ncenters
    myresult(:,i)= unarypotF(i).*gaussPDF(A,muF(:,i),sigmaF(:,:,i));%�ý��Ϊnrow*ncol�� 1�е�myresult(:,i)+
    gauss_result(:,i)=sum(myresult,2);%nrow*ncol�� 1�е�

end%myresult ��ά��Ϊnrow*ncol�� 1�е� ncenters��


w(:,:,ncenters)=reshape(gauss_result(:,ncenters),nrow,ncol);%���

%��ʾ���
%figure
% subplot(2,1,1); imshow(w(:,:,k));
% subplot(2,1,1);imshow(data_w(:,:,k));

%����߶ȣ�����ʾ���
figure
subplot(2,1,1); imshow(w(:,:,ncenters).*255) ;
title(['��',num2str(ncenters),'��GMMģ��������ͼ����ܶ�*255']);
%subplot(2,1,2); imshow(data_w(:,:,k).*255);title(['��',num2str(k),'����ɫ���û�Ϳѻ����ܶ�*255']);

%��0����

myresult=zeros(size(myresult));
%X_PDF=zeros(nrow*ncol,1);

% %�����
% size(find(data_w(:,:,k)>0))



%������ص�����
     currentpath=pwd;
     storageName =[pwd '\results\'];
    save ([storageName 'image_PDF'], 'w')
  %  save ([storageName 'data_PDF'] , 'data_w');
end