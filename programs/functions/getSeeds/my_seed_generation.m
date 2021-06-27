function [nlabels, labels, idx, ref, seeds1, seeds2] = my_seed_generation(ref_name,Scricolor,scale)
%����
%ref_nameΪ�����û�Ϳѻ��ͼƬ��
%scaleΪ���ųߴ�
%%%�û�Ϳѻ����ɫ  Scricolor ΪN*3�ľ���ÿ��һ����ɫ��ÿ����ɫΪRGBɫ

%���
%nlabels Ϊ�û�Ϳѻ����ɫ����
%labels �� idx ���ڴ���û�Ϳѻ����Ϣ���ڼ�����ɫ����Щλ��

global EachImage index_eachMarkedImage;

if nargin<3, scale = 1; end;
ref=im2double(imread(ref_name)); ref = imresize(ref,scale);

nlabels =size(Scricolor,1);%ͳ���ж�������ɫ���û�Ϳѻ
% figure %��ʾ���û�Ϳѻ��ͼƬ
% imshow(ref);

num = 0; %��������ͳ���ж������ص㱻�û�Ϳѻ


for i=1:nlabels
    L{i} = find(ref(:,:,1)==Scricolor(i,1) & ref(:,:,2)==Scricolor(i,2) & ref(:,:,3)==Scricolor(i,3)); % R
    nL = size(L{i},1); % ��i����ɫ�����ص����
    % if nL > 0
    labels(num+1:num+nL) = i;
    idx(num+1:num+nL) = L{i};
    num = num + nL;
    
    %%������ӵģ�������ʾ�û��Ļ���
    % %�����һ�δ��룬������ʾͼƬ�е��û�Ϳѻ��
    %%���Բ���
    [nrow,ncol,nbdata]=size(ref);
    seeds{i}=ones(nrow,ncol,3);
    seeds{i}=reshape(seeds{i},[],3);
    temp=seeds{i};
    temp(L{i},1)=Scricolor(i,1);
    temp(L{i},2)=Scricolor(i,2);
    temp(L{i},3)=Scricolor(i,3);
    seeds{i}=temp;
    seeds{i}=reshape(seeds{i},nrow,ncol,nbdata);
    % 	myseeds=zeros(nrow,ncol,3);
    %imshow(myseeds)
    % 		myseeds=reshape(myseeds,[],3);
    % 		myseeds(L{i},1)=Scricolor(i,1);
    % 	myseeds(L{i},2)=Scricolor(i,2);
    % 	myseeds(L{i},3)=Scricolor(i,3);
    % 	myseeds=reshape(myseeds,nrow,ncol,nbdata);
end

seedsIndex1=L{1,1};
seedsIndex2=L{1,2};
seeds1=seeds{1};
seeds2=seeds{2};



% %     subplot(nlabels,1,i),imshow(myseeds)
%% ����myseeds����
filename_seedsIndex1 = [EachImage.originalImage(index_eachMarkedImage).name(1:end-4) '_seedsIndex1' '.mat'];
filepath_seedsIndex1 = fullfile(EachImage.folderpath_seedsIndex1, filename_seedsIndex1);
save(filepath_seedsIndex1,'seedsIndex1');
disp(['�ѱ��������� ' filename_seedsIndex1]);

filename_seedsIndex2 = [EachImage.originalImage(index_eachMarkedImage).name(1:end-4) '_seedsIndex2' '.mat'];
filepath_seedsIndex2 = fullfile(EachImage.folderpath_seedsIndex2, filename_seedsIndex2);
save(filepath_seedsIndex2,'seedsIndex2');
disp(['�ѱ��������� ' filename_seedsIndex2]);

filename_seeds1 = [EachImage.originalImage(index_eachMarkedImage).name(1:end-4) '_seeds1' '.mat'];
filepath_seeds1 = fullfile(EachImage.folderpath_seeds1, filename_seeds1);
save(filepath_seeds1,'seeds1');
disp(['�ѱ��������� ' filename_seeds1]);

filename_seeds2 = [EachImage.originalImage(index_eachMarkedImage).name(1:end-4) '_seeds2' '.mat'];
filepath_seeds2 = fullfile(EachImage.folderpath_seeds2, filename_seeds2);
save(filepath_seeds2,'seeds2');
disp(['�ѱ��������� ' filename_seeds2]);

filename_seedsImg1 = [EachImage.originalImage(index_eachMarkedImage).name(1:end-4) '_seeds1' '.bmp'];
filepath_seedsImg1 = fullfile(EachImage.folderpath_seedsImg1, filename_seedsImg1);
imwrite(seeds1,filepath_seedsImg1);
disp(['�ѱ��������� ' filename_seedsImg1]);

filename_seedsImg2 = [EachImage.originalImage(index_eachMarkedImage).name(1:end-4) '_seeds2' '.bmp'];
filepath_seedsImg2 = fullfile(EachImage.folderpath_seedsImg2, filename_seedsImg2);
imwrite(seeds2,filepath_seedsImg2);
disp(['�ѱ��������� ' filename_seedsImg2]);

end

