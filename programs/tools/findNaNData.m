clear all;
close all;
clc;
diary off;


%%
EachImage = createEachImageStructure(0);
idx_org = findIndexOfFolderName(EachImage, 'original images');
idx_gt = findIndexOfFolderName(EachImage, 'ground truth images');
idx_bw = findIndexOfFolderName(EachImage, 'bw images');

%% 构建results文件夹里指定做的指标的文件路径和名称的结构体 Results
Results = createResultsStructure;


%%
for index_experiment = 1:Results.num_experiments
	load(fullfile(Results.experiments(index_experiment).folderpath_evaluationData , 'F1.mat' ));
	nanPos = find(isnan(F1));
	
	k=1;
	figure('Position',[0 0 600 2000]);
	for i=1:length(nanPos)
		
		subplot(length(nanPos),3,k)
		image(imread(EachImage.folders(idx_org).files(nanPos(i)).path));
		k=k+1;
		
		subplot(length(nanPos),3,k)
		
		imagesc(imread(EachImage.folders(idx_gt).files(nanPos(i)).path));colormap(gray);
		k=k+1;
		
		subplot(length(nanPos),3,k)
		
		imagesc(imread(EachImage.folders(idx_bw).files(nanPos(i)).path));colormap(gray);
		
		
		k=k+1;
	end
	
	
end





















