function [ output_args ] = statistic_forPaper( Pros, EachImage, Results )
%STATISTIC 统计和寻找符合要求的图像
%   此处显示详细说明

for i=1:Results.num_experiments
	% 			filenameStr = '_Jaccard_compareTwo' ;
	load(fullfile(Results.experiments(i).folderpath_evaluationData, 'jaccardDistance.mat'));
	jaccardDistance(i)=jaccardDistance;
end
labelStr_JD= 'Jaccard Distance';
ceilValue_JD = 1;
isReverseAxes_JD = 'yes';

for i=1:Results.num_experiments
	% 			filenameStr = '_Jaccard_compareTwo' ;
	load(fullfile(Results.experiments(i).folderpath_evaluationData, 'modifiedHausdorffDistance.mat'));
	modifiedHausdorffDistance(i)=modifiedHausdorffDistance;
end
labelStr_MHD = 'Modified Hausdorff Distance';
ceilValue_MHD = max(max(modifiedHausdorffDistance_1),max(modifiedHausdorffDistance_2));
isReverseAxes_MHD = 'yes';

for i=1:Results.num_experiments
	% 			filenameStr = '_Jaccard_compareTwo' ;
	load(fullfile(Results.experiments(i).folderpath_evaluationData, 'F1.mat'));
	F1(i)=F1;
end
labelStr_F1 = 'F1';
ceilValue_F1 = 1;
isReverseAxes_F1 = 'no';


%% 统计对比两种方法在各自指标下，图像数量的属性

% 在JD指标下，各种方法处理效果不差，且实验组比两个对照组的效果都好一些的图像
imagesBothNotBad_JD(:,1) = find(jaccardDistance(i)<=(1-Pros.ratioOfBad)*ceilValue);
for i=1:Results.num_experiments
	imagesBothNotBad_JD(:,i+1) = jaccardDistance(imagesBothNotBad_JD(:,1),i);
end
num_imagesBothNotBad_JD=size(imagesBothNotBad_JD,1);

% 在MHD指标下，各种方法处理效果不差，且实验组比两个对照组的效果都好一些的图像
imagesBothNotBad_MHD(:,1) = find(modifiedHausdorffDistance(i)<=(1-Pros.ratioOfBad)*ceilValue);
for i=1:Results.num_experiments
	imagesBothNotBad_MHD(:,i+1) = modifiedHausdorffDistance(imagesBothNotBad_MHD(:,1),i);
end
num_imagesBothNotBad_MHD=size(imagesBothNotBad_MHD,1);

% 在F1指标下，各种方法处理效果不差，且实验组比两个对照组的效果都好一些的图像
imagesBothNotBad_F1(:,1) = find(F1(i)<=(1-Pros.ratioOfBad)*ceilValue);
for i=1:Results.num_experiments
	imagesBothNotBad_F1(:,i+1) = F1(imagesBothNotBad_F1(:,1),i);
end
num_imagesBothNotBad_F1=size(imagesBothNotBad_F1,1);











end

