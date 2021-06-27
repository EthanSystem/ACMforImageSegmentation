function [ output_args ] = visualizeNeedBwImageForPaper( Pros, EachImage, Results, isVisual, labelStr, index_experiment01, index_experiment02 ,array_images, name_conditionOfCompare )
%VISUALIZENEEDBWIMAGEFORPAPER ���ӻ����������Ķ�ֵͼ����������չʾ��
%   �˴���ʾ��ϸ˵��
if strcmp(isVisual,'yes')==1
    controlVis = 'on';
else
    controlVis = 'off';
end

%%
name_experiment01=Results.experiments(index_experiment01).name;
name_experiment02=Results.experiments(index_experiment02).name;
str_experiment01=strrep(name_experiment01,'_','\_');
str_experiment02=strrep(name_experiment02,'_','\_');

foldername_visNeedBwImgForPaper = 'visNeedBwImgForPaper';
folderpath_visNeedBwImgForPaper = fullfile(Pros.folderpath_experiment,foldername_visNeedBwImgForPaper);
if ~exist(folderpath_visNeedBwImgForPaper,'dir')
    mkdir(folderpath_visNeedBwImgForPaper);
end

data_1 = array_images;
row=5;
col=8;

% eval(['data_2=' name_evaluationData_2 ';']);


%% load
% filename_imagesGoodAt1 = ['imagesGoodAt1' filenameStr '.mat'];
% filepath_imagesGoodAt1 = fullfile(Pros.folderpath_experiment, filename_imagesGoodAt1);
% load(filepath_imagesGoodAt1);
%
% filename_imagesGoodAt2 = ['imagesGoodAt2' filenameStr '.mat'];
% filepath_imagesGoodAt2 = fullfile(Pros.folderpath_experiment, filename_imagesGoodAt2);
% load(filepath_imagesGoodAt2);
%
% filename_imagesBadAt1 = ['imagesBadAt1' filenameStr '.mat'];
% filepath_imagesBadAt1 = fullfile(Pros.folderpath_experiment, filename_imagesBadAt1);
% load(filepath_imagesBadAt1);
%
% filename_imagesBadAt2 = ['imagesBadAt2' filenameStr '.mat'];
% filepath_imagesBadAt2 = fullfile(Pros.folderpath_experiment, filename_imagesBadAt2);
% load(filepath_imagesBadAt2);
%
% filename_imagesGoodAt1and2 = ['imagesGoodAt1and2' filenameStr '.mat'];
% filepath_imagesGoodAt1and2 = fullfile(Pros.folderpath_experiment, filename_imagesGoodAt1and2);
% load(filepath_imagesGoodAt1and2);
%
% filename_images1better2AtBothGood = ['images1better2AtBothGood' filenameStr '.mat'];
% filepath_images1better2AtBothGood = fullfile(Pros.folderpath_experiment, filename_images1better2AtBothGood);
% load(filepath_images1better2AtBothGood);
%
% filename_images2better1AtBothGood = ['images2better1AtBothGood' filenameStr '.mat'];
% filepath_images2better1AtBothGood = fullfile(Pros.folderpath_experiment, filename_images2better1AtBothGood);
% load(filepath_images2better1AtBothGood);
%
% filename_images1better2And1GoodAnd2NotBad = ['images1better2And1GoodAnd2NotBad' filenameStr '.mat'];
% filepath_images1better2And1GoodAnd2NotBad = fullfile(Pros.folderpath_experiment, filename_images1better2And1GoodAnd2NotBad);
% load(filepath_images1better2And1GoodAnd2NotBad);
%
% filename_images2better1And2GoodAnd1NotBad = ['images2better1And2GoodAnd1NotBad' filenameStr '.mat'];
% filepath_images2better1And2GoodAnd1NotBad = fullfile(Pros.folderpath_experiment, filename_images2better1And2GoodAnd1NotBad);
% load(filepath_images2better1And2GoodAnd1NotBad);
%


%% ����ʽ
num_image = size(data_1,1);

if(num_image > Pros.numImagesShow)
    num_image = Pros.numImagesShow;
end

figure010 = figure('Name',['���ַ����ָ� ' num2str(Pros.numImagesShow) ' ��ɸѡ��ͼ���� ' labelStr ' ָ���µĶԱ�ͼ'],'Position',[20 20 1500 1200],'Visible',controlVis);



%% �о��������Ӧ��ͼ�������ã�
% original image
for index_image=1:num_image
    subplot(row,col,index_image);
    image010 = imread(EachImage.originalImage(data_1(index_image,1)).path);
    imshow(image010);
    axis equal;
    axis off;
    title(strrep(EachImage.originalImage(data_1(index_image,1)).name,'_','\_'));
end
% save figure
filename_figure = ['��ָ�� ' labelStr ' �·���Ҫ�� ' name_conditionOfCompare ' �� ' num2str(num_image) ' ��ͼ���ԭͼ.jpg'];
filepath_figure = fullfile(folderpath_visNeedBwImgForPaper, filename_figure);
saveas(figure010,filepath_figure);

% bw image of ground truth
for index_image=1:num_image
    subplot(row,col,index_image);
    image010 = imread(EachImage.groundTruthBwImage(data_1(index_image,1)).path);
    imshow(image010);
    axis equal;
    axis off;
    title(strrep(EachImage.originalImage(data_1(index_image,1)).name,'_','\_'));
end
% save figure
filename_figure = ['��ָ�� ' labelStr ' �·���Ҫ�� ' name_conditionOfCompare ' �� ' num2str(num_image) ' ��ͼ�����ֵͼ.jpg'];
filepath_figure = fullfile(folderpath_visNeedBwImgForPaper, filename_figure);
saveas(figure010,filepath_figure);

for index_image=1:num_image
    % bw image of method 1
    for index_image=1:num_image
        subplot(row,col,index_image);
        image010 = imread(Results.experiments(index_experiment01).bwImages(data_1(index_image,1)).path);
        imshow(image010);
        axis equal;
        axis off;
        title(strrep(EachImage.originalImage(data_1(index_image,1)).name,'_','\_'));
    end
    % save figure
    filename_figure = ['��ָ�� ' labelStr ' �·���Ҫ�� ' name_conditionOfCompare ' �� ' num2str(num_image) ' ��ͼ��Ķ�ֵͼ.jpg'];
    filepath_figure = fullfile(folderpath_visNeedBwImgForPaper, filename_figure);
    saveas(figure010,filepath_figure);
    
end




