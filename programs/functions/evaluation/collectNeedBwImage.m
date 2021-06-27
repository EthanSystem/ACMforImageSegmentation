function [ output_args ] = collectNeedBwImage( Pros, EachImage, Results, index_experiment01, index_experiment02 ,array_images, typeOfIndicator, name_conditionOfCompare  )
%COLLECTNEEDBWIMAGE �ռ����������Ķ�ֵͼ��ָ�����ļ���
%   �˴���ʾ��ϸ˵��

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

%% Ѱ�ҷ���������ԭͼ����ֵ��ֵͼ������һ�Ķ�ֵͼ���������Ķ�ֵͼ������һ���ļ�����
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

