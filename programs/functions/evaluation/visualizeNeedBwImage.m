function [ output_args ] = visualizeNeedBwImage(Pros, EachImage, Results, isVisual, labelStr, index_experiment01, index_experiment02 ,array_images, name_conditionOfCompare )
%VISUALIZENEEDBWIMAGE 可视化符合条件的二值图像
%   此处显示详细说明
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

foldername_visNeedBwImg = 'visBwImgForPaper';
folderpath_visNeedBwImg = fullfile(Pros.folderpath_experiment,foldername_visNeedBwImg);
if ~exist(folderpath_visNeedBwImg,'dir')
	mkdir(folderpath_visNeedBwImg);
end

%%
data_1 = array_images;
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


%% 排序方式
num_image = size(data_1,1);

if(num_image > Pros.numImagesShow)
	num_image = Pros.numImagesShow;
end

figure010 = figure('Name',['两种方法分割 ' num2str(num_image) ' 张筛选的图像在 ' labelStr ' 指标下的对比图'],'Position',[20 20 2000 600*num_image],'Visible',controlVis);

%% 列举数据里对应的图像
% suptitle(['两种方法分割 ' num2str(num_image) ' 张筛选的图像在 ' labelStr ' 指标下的对比图']);
k=1;
for index_image=1:num_image
	% original image
	subplot(num_image,4,k);
	image010 = imread(EachImage.originalImage(data_1(index_image,1)).path);
	imshow(image010);
	axis equal;
	axis off;
	title(strrep(EachImage.originalImage(data_1(index_image,1)).name,'_','\_'));
	k=k+1;
	% bw image of ground truth
	subplot(num_image,4,k);
	image020 = imread(EachImage.groundTruthBwImage(data_1(index_image,1)).path);
	imshow(image020);
	axis equal;
	axis off;
	title(strrep(EachImage.groundTruthBwImage(data_1(index_image,1)).name,'_','\_'));
	k=k+1;
	% bw image of method 1
	subplot(num_image,4,k);
	image030 = imread(Results.experiments(index_experiment01).bwImages(data_1(index_image,1)).path);
	imshow(image030);
	axis equal;
	axis off;
	title(['bw-image at ' str_experiment01]);
	k=k+1;
	% bw image of method 2
	subplot(num_image,4,k);
	image040 = imread(Results.experiments(index_experiment02).bwImages(data_1(index_image,1)).path);
	imshow(image040);
	axis equal;
	axis off;
	title(['bw-image at ' str_experiment02]);
	k=k+1;
end
% save figure
filename_figure = ['方法' num2str(index_experiment01) ' 对比 ' num2str(index_experiment02) ' 在指标 ' labelStr ' 下符合要求 ' name_conditionOfCompare ' 的筛选对比图.jpg'];
filepath_figure = fullfile(folderpath_visNeedBwImg, filename_figure);
saveas(figure010,filepath_figure);


