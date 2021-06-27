function [ output_args ] = statistic_forPaper( Pros, EachImage, Results )
%STATISTIC ͳ�ƺ�Ѱ�ҷ���Ҫ���ͼ��
%   �˴���ʾ��ϸ˵��

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


%% ͳ�ƶԱ����ַ����ڸ���ָ���£�ͼ������������

% ��JDָ���£����ַ�������Ч�������ʵ����������������Ч������һЩ��ͼ��
imagesBothNotBad_JD(:,1) = find(jaccardDistance(i)<=(1-Pros.ratioOfBad)*ceilValue);
for i=1:Results.num_experiments
	imagesBothNotBad_JD(:,i+1) = jaccardDistance(imagesBothNotBad_JD(:,1),i);
end
num_imagesBothNotBad_JD=size(imagesBothNotBad_JD,1);

% ��MHDָ���£����ַ�������Ч�������ʵ����������������Ч������һЩ��ͼ��
imagesBothNotBad_MHD(:,1) = find(modifiedHausdorffDistance(i)<=(1-Pros.ratioOfBad)*ceilValue);
for i=1:Results.num_experiments
	imagesBothNotBad_MHD(:,i+1) = modifiedHausdorffDistance(imagesBothNotBad_MHD(:,1),i);
end
num_imagesBothNotBad_MHD=size(imagesBothNotBad_MHD,1);

% ��F1ָ���£����ַ�������Ч�������ʵ����������������Ч������һЩ��ͼ��
imagesBothNotBad_F1(:,1) = find(F1(i)<=(1-Pros.ratioOfBad)*ceilValue);
for i=1:Results.num_experiments
	imagesBothNotBad_F1(:,i+1) = F1(imagesBothNotBad_F1(:,1),i);
end
num_imagesBothNotBad_F1=size(imagesBothNotBad_F1,1);











end

