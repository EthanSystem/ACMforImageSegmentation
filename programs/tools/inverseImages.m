%% 简介
% inverseImages.m 反转图像的BW值

%% 预处理
clear all;
close all;
clc;
diary off;
sp=actxserver('SAPI.SpVoice');


%% 用户输入初始参数 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Args.folderpath_EachImageBaseFolder = '.\data\resources\比较同一时间'; % 用于计算文件的结构体 EachImage 的基本路径
Args.folderpath_ResultsBaseFolder = '.\data\calculations\比较同一时间'; % 用于计算文件的结构体 Results 的基本路径。
Args.beta = 1; % the value of beta in F1 evaluation.
Args.num_scribble=1; % 所有待处理的图像的标记总数。由于目前暂时不考虑不同标记对分割效果的影响，而仅仅用一张图像一种标记，因此目前手动设置为1。
Args.numUselessFiles = 0; % 要处理的图像数量。有时候存储图片的文件夹除了有图像文件，还有可能是系统文件，会被误处理，因此需要手动排除
Args.mode = '1' ; % '1' 表示反转图像，'2' 表示不反转图像
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% properties
Pros = Args;
% disp(Pros.mode)

Pros.num_scribble =1; % 标记的数量。目前不考虑不同的标记对实验结果的影响，因此设置为1

%% 构建文件夹的资源resources 结构体EachImage 构建results文件夹里指定做的指标的文件路径和名称的结构体 Results
EachImage = createEachImageStructure(Pros.folderpath_EachImageBaseFolder,Pros.numUselessFiles);
Results = createResultsStructure(Pros.folderpath_ResultsBaseFolder ,Pros.numUselessFiles);

input('确认文件夹里的文件数量是否正确？正确按任意键继续，否则按 Ctrl+c 终止程序。')

% Pros.indexOfScribbledImageFolder = findIndexOfFolderName(EachImage, 'scribbled images');
% Pros.indexOfOriginalImageFolder = findIndexOfFolderName(EachImage, 'original images');
% Pros.indexOfBwDataFolder = findIndexOfFolderName(EachImage, 'bw data');
% Pros.indexOfBwImagesFolder = findIndexOfFolderName(EachImage, 'bw images');
% Pros.indexOfGTFolder = findIndexOfFolderName(EachImage, 'ground truth images');
% Pros.indexOfEvaluationsFolder = findIndexOfFolderName(EachImage, 'evaluations');
% Pros.indexOfFiguresFolder = findIndexOfFolderName(EachImage, 'figures');
%


%% 计算评价值
%% 遍历所有实验文件夹评价指标进行评价

Pros.num_image = EachImage.num_groundTruthBwImage ;
jaccardIndex=1./zeros(Pros.num_image,Pros.num_scribble);
jaccardDistance=1./zeros(Pros.num_image,Pros.num_scribble);
modifiedHausdorffDistance=1./zeros(Pros.num_image, Pros.num_scribble);
Precision=1./zeros(Pros.num_image, Pros.num_scribble);
Recall=1./zeros(Pros.num_image, Pros.num_scribble);
F1=1./zeros(Pros.num_image, Pros.num_scribble);

tic;

for index_experiment = 1:Results.num_experiments
	
	% 生成diary输出文件夹
	Pros.foldername_diary = 'diary output';
	Pros.folderpath_diary = fullfile(Results.experiments(index_experiment).folderpath, Pros.foldername_diary);
	if ~exist(Pros.folderpath_diary,'dir')
		mkdir(Pros.folderpath_diary );
	end
	Pros.filepath_diary = fullfile(Pros.folderpath_diary , ['diary evaluation calculate.txt']);
	diary(Pros.filepath_diary);
	diary on;
	
	
	%% 评价指标的计算
	switch Pros.mode
		
		case '1'
			for index_image = 1:Pros.num_image
				for index_scribble=1:Pros.num_scribble
					disp(['experiment ' num2str(index_experiment) '    image ' num2str(index_image) '    scribble ' num2str(index_scribble)]);
					
					filepath_groundTruthImages = EachImage.groundTruthBwImage(index_image).path;
					filename_bwData = Results.experiments(index_experiment).bwImages(index_image).name;
					filepath_bwData = Results.experiments(index_experiment).bwImages(index_image).path;
					gtImage = imread(filepath_groundTruthImages);
					bwData_1=imread(filepath_bwData);
					bwData_2=~bwData_1;
					
					%% 计算指标（会反转图像）
					% 因为无监督分割可能分割出来的前景和背景是相反的，所以需要判断是否出现这种情况，并且做反转处理，找出表现最好的图像，并且覆盖原来的文件。
					% jaccardDistance
					[jaccardIndex_temp_1, jaccardDistance_temp_1] = Jacard_evaluation(gtImage, bwData_1);
					[jaccardIndex_temp_2, jaccardDistance_temp_2] = Jacard_evaluation(gtImage, bwData_2);
					
					if jaccardDistance_temp_1<=jaccardDistance_temp_2
						jaccardDistance(index_image)=jaccardDistance_temp_1;
						jaccardIndex(index_image)=jaccardIndex_temp_1;
					else
						jaccardDistance(index_image)=jaccardDistance_temp_2;
						jaccardIndex(index_image)=jaccardIndex_temp_2;
						imwrite(bwData_2, filepath_bwData);
						disp(['已经在 jaccard 相关 指标的计算中对 ' filename_bwData ' 进行反转处理。'])
					end
					
					% Modified Hausdorff distance
					[modifiedHausdorffDistance_temp_1] = ModHausdorffDist(gtImage, bwData_1);
					[modifiedHausdorffDistance_temp_2] = ModHausdorffDist(gtImage, bwData_2);
					if modifiedHausdorffDistance_temp_1<=modifiedHausdorffDistance_temp_2
						modifiedHausdorffDistance(index_image)=modifiedHausdorffDistance_temp_1;
					else
						modifiedHausdorffDistance(index_image)=modifiedHausdorffDistance_temp_2;
						imwrite(bwData_2, filepath_bwData);
						disp(['已经在 Modified Hausdorff distance 指标的计算中对 ' filename_bwData ' 进行反转处理。'])
						
					end
					
					% P-R
					[Precision_temp_1, Recall_temp_1, F1_temp_1]=PR_evaluation(gtImage,bwData_1,sqrt(0.3));
					[Precision_temp_2, Recall_temp_2, F1_temp_2]=PR_evaluation(gtImage,bwData_2,sqrt(0.3));
					% 因为无监督分割可能分割出来的前景和背景是相反的，并且可能会出现在混淆矩阵中出现F1指标式子的分母是0，结果计算出NaN的情况。所以需要判断是否出现这种情况，并且做反转处理，找出表现最好的图像。
					
					% calculate F1
					if (isnan(F1_temp_1)==0 && isnan(F1_temp_2)==0)
						if F1_temp_1>=F1_temp_2
							Precision(index_image, index_scribble)=Precision_temp_1;
							Recall(index_image, index_scribble)=Recall_temp_1;
							F1(index_image)=F1_temp_1;
						else
							Precision(index_image, index_scribble)=Precision_temp_2;
							Recall(index_image, index_scribble)=Recall_temp_2;
							F1(index_image)=F1_temp_2;
							imwrite(bwData_2, filepath_bwData);
							disp(['已经在 F1 指标的计算中对 ' filename_bwData ' 进行反转处理。'])
						end
					else
						if (isnan(F1_temp_1)==1 && isnan(F1_temp_2)==0)
							F1(index_image)=F1_temp_2;
						else
							F1(index_image)=F1_temp_1;
						end
					end
					
					
					% macro-F1
					[macroPrecision, macroRecall, macroF1]=macroPR_evaluation(Precision,Recall,F1);
					
					
					
				end % end scribble loop
			end % end image loop
			
		case '2'
			%% 计算指标（不反转图像）
			for index_image = 1:Pros.num_image
				for index_scribble=1:Pros.num_scribble
					
					disp(['experiment ' num2str(index_experiment) '    image ' num2str(index_image) '    scribble ' num2str(index_scribble)]);
					
					filepath_groundTruthImages = EachImage.groundTruthBwImage(index_image).path;
					filename_bwData = Results.experiments(index_experiment).bwImages(index_image).name;
					filepath_bwData = Results.experiments(index_experiment).bwImages(index_image).path;
					gtImage = imread(filepath_groundTruthImages);
					bwData_1=imread(filepath_bwData);
					
					
					
					% jaccardDistance
					[jaccardIndex_temp_1, jaccardDistance_temp_1] = Jacard_evaluation(gtImage, bwData_1);
					jaccardIndex(index_image)=jaccardIndex_temp_1;
					jaccardDistance(index_image)=jaccardDistance_temp_1;
					
					% 					Modified Hausdorff distance
					[modifiedHausdorffDistance_temp_1] = ModHausdorffDist(gtImage, bwData_1);
					modifiedHausdorffDistance(index_image)=modifiedHausdorffDistance_temp_1;
					
					% P-R
					[Precision_temp_1, Recall_temp_1, F1_temp_1]=PR_evaluation(gtImage,bwData_1,sqrt(0.3));
					Precision(index_image, index_scribble)=Precision_temp_1;
					Recall(index_image, index_scribble)=Recall_temp_1;
					F1(index_image)=F1_temp_1;
					
					
					% macro-F1
					[macroPrecision, macroRecall, macroF1]=macroPR_evaluation(Precision,Recall,F1);
					
					
				end % end scribble loop
			end % end image loop
	end % end switch
	
	
	
	%% 保存数据
	Pros.folderpath_evaluationsData = Results.experiments(index_experiment).folderpath_evaluationData;
	save(fullfile(Pros.folderpath_evaluationsData, 'jaccardIndex.mat'), 'jaccardIndex');
	save(fullfile(Pros.folderpath_evaluationsData, 'jaccardDistance.mat'), 'jaccardDistance');
	save(fullfile(Pros.folderpath_evaluationsData, 'modifiedHausdorffDistance.mat'), 'modifiedHausdorffDistance');
	save(fullfile(Pros.folderpath_evaluationsData, 'F1.mat'), 'F1');
	save(fullfile(Pros.folderpath_evaluationsData, 'Precision.mat'), 'Precision');
	save(fullfile(Pros.folderpath_evaluationsData, 'Recall.mat'), 'Recall');
	save(fullfile(Pros.folderpath_evaluationsData, 'macroF1.mat'), 'macroF1');
	
	
	%% 关闭日志记录
	diary off;
	
end % end experiment loop





%%
toc;
text=['程序运行完毕。'];
disp(text);
sp.Speak(text);

% diary off;




