function  visualizeCompareTwoMethod( typeOfIndicator, Pros, EachImage, Results, index_experiment01, index_experiment02 ,isVisual)
%VISUALIZECOMPARETWOMETHOD 此处显示有关此函数的摘要
%   此处显示详细说明
if strcmp(isVisual,'yes')==1
	controlVis = 'on';
else
	controlVis = 'off';
end

switch typeOfIndicator
	case 'Jaccard'
		filenameStr = '_Jaccard_compareTwo' ;
		load(fullfile(Results.experiments(index_experiment01).folderpath_evaluationData, 'jaccardDistance.mat'));
		jaccardDistance_1=jaccardDistance;
		name_evaluationData_1 = 'jaccardDistance_1';
		clear jaccardDistance;
		load(fullfile(Results.experiments(index_experiment02).folderpath_evaluationData, 'jaccardDistance.mat'));
		jaccardDistance_2=jaccardDistance;
		clear jaccardDistance;
		name_evaluationData_2 = 'jaccardDistance_2';
		labelStr = 'Jaccard Distance';
		ceilValue = 1;
		limAxes = [0 1];
		isReverseAxes = 'yes';
		
	case 'ModifiedHausdorff'
		filenameStr = '_ModiHausdorff_compareTwo' ;
		load(fullfile(Results.experiments(index_experiment01).folderpath_evaluationData, 'modifiedHausdorffDistance.mat'));
		modifiedHausdorffDistance_1=modifiedHausdorffDistance;
		name_evaluationData_1 = 'modifiedHausdorffDistance_1';
		clear modifiedHausdorffDistance;
		load(fullfile(Results.experiments(index_experiment02).folderpath_evaluationData, 'modifiedHausdorffDistance.mat'));
		modifiedHausdorffDistance_2=modifiedHausdorffDistance;
		clear modifiedHausdorffDistance;
		name_evaluationData_2 = 'modifiedHausdorffDistance_2';
		labelStr = 'Modified Hausdorff Distance';
		ceilValue = max(max(modifiedHausdorffDistance_1),max(modifiedHausdorffDistance_2));
		limAxes = [0 ceil(1.2.*max(max(modifiedHausdorffDistance_1),max(modifiedHausdorffDistance_2)))];
		isReverseAxes = 'yes';
		
	case 'F1'
		filenameStr = '_F1_compareTwo' ;
		load(fullfile(Results.experiments(index_experiment01).folderpath_evaluationData, 'F1.mat'));
		F1_1=F1;
		name_evaluationData_1 = 'F1_1';
		clear F1;
		load(fullfile(Results.experiments(index_experiment02).folderpath_evaluationData, 'F1.mat'));
		F1_2=F1;
		clear F1;
		name_evaluationData_2 = 'F1_2';
		labelStr = 'F1';
		ceilValue = 1;
		limAxes = [0 1];
		isReverseAxes = 'no';
		
	otherwise
		error('error to choose type');
end


eval(['X1=' name_evaluationData_1 ';']);
eval(['Y1=' name_evaluationData_2 ';']);

%% 两个算法所有图像的指标比较
% 创建 figure
figure1 = figure('Name',['两种方法分割 ' num2str(Pros.num_image) ' 张图像在 ' labelStr ' 指标下的分布图'],'Position',[20 20 Pros.figSize(1) Pros.figSize(2)],'Visible',controlVis);
name_experiment01=Results.experiments(index_experiment01).name;
name_experiment02=Results.experiments(index_experiment02).name;
str_experiment01=strrep(name_experiment01,'_','\_');
str_experiment02=strrep(name_experiment02,'_','\_');

% 创建 axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% 创建 比较
scatter010 = scatter(X1,Y1,Pros.markerSize,'filled','o','MarkerEdgeColor','k','MarkerFaceColor','r');
axes1.XLim = limAxes;
axes1.YLim = limAxes;

% 创建 line
plot(limAxes,limAxes,'-.b');
if strcmp(isReverseAxes,'yes')==1
	plot(limAxes,[(1-Pros.ratioOfGood)*ceilValue,(1-Pros.ratioOfGood)*ceilValue],'-.b');
	plot(limAxes,[(1-Pros.ratioOfBad)*ceilValue,(1-Pros.ratioOfBad)*ceilValue],'-.b');
	plot([(1-Pros.ratioOfGood)*ceilValue,(1-Pros.ratioOfGood)*ceilValue],limAxes,'-.b');
	plot([(1-Pros.ratioOfBad)*ceilValue,(1-Pros.ratioOfBad)*ceilValue],limAxes,'-.b');
end

if strcmp(isReverseAxes,'no')==1
	plot(limAxes,[Pros.ratioOfGood*ceilValue,Pros.ratioOfGood*ceilValue],'-.b');
	plot(limAxes,[Pros.ratioOfBad*ceilValue,Pros.ratioOfBad*ceilValue],'-.b');
	plot([Pros.ratioOfGood*ceilValue,Pros.ratioOfGood*ceilValue],limAxes,'-.b');
	plot([Pros.ratioOfBad*ceilValue,Pros.ratioOfBad*ceilValue],limAxes,'-.b');
end


xlabel(['方法 ' str_experiment01 ' 的 ' labelStr ' 指标'],'FontSize',12,'FontWeight','bold');
ylabel(['方法 ' str_experiment02 ' 的 ' labelStr ' 指标'],'FontSize',12,'FontWeight','bold');
% 	axis equal;
title(['两种方法分割 ' num2str(Pros.num_image) ' 张图像在 ' labelStr ' 指标下的分布图']);

filename_figure=[name_experiment01 ' & ' name_experiment02 filenameStr '.png'];
filepath_figure=fullfile(Pros.folderpath_experiment, filename_figure);
saveas(figure1, filepath_figure)








end





