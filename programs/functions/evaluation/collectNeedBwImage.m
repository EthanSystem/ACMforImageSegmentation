function [ output_args ] = collectNeedBwImage( Pros, EachImage, Results, index_experiment01, index_experiment02 ,array_images, typeOfIndicator, name_conditionOfCompare  )
%COLLECTNEEDBWIMAGE 收集符合条件的二值图像到指定的文件夹
%   此处显示详细说明

name_experiment01=Results.experiments(index_experiment01).name;
name_experiment02=Results.experiments(index_experiment02).name;
str_experiment01=strrep(name_experiment01,'_','\_');
str_experiment02=strrep(name_experiment02,'_','\_');

data_1 = array_images;

num_image = size(data_1,1);
% 
% if(num_image > Pros.numImagesShow)
% 	num_image = Pros.numImagesShow;
% end

%% 寻找符合条件的原图、真值二值图、方法一的二值图、方法二的二值图，放入一个文件夹中
folderpath_imageConditionOfCompare = fullfile(Pros.folderpath_experiment, [name_conditionOfCompare '_' typeOfIndicator]);
if ~exist(folderpath_imageConditionOfCompare,'dir')
	mkdir(folderpath_imageConditionOfCompare);
end
for index_image=1:num_image
	copyfile(EachImage.originalImage(data_1(index_image,1)).path, folderpath_imageConditionOfCompare);
	copyfile(EachImage.groundTruthBwImage(data_1(index_image,1)).path, folderpath_imageConditionOfCompare);
	copyfile(Results.experiments(index_experiment01).bwImages(data_1(index_image,1)).path, folderpath_imageConditionOfCompare);
	copyfile(Results.experiments(index_experiment02).bwImages(data_1(index_image,1)).path, folderpath_imageConditionOfCompare);
end



end

