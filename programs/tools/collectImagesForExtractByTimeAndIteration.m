%% 简介
% collectImagesForExtractByHuman.m 实现提取分别满足 Iteration 和 Time 的两个条件的各个方法的图像以及真值图到指定文件夹以便于人工筛选
% 提取指定的文件和文件夹的模式有如下三种：
% 模式1 表示在带有较强的评价指标的第一轮筛选下，提取相应图像。
% 模式2 表示在带有较弱的评价指标的第一轮筛选下，提取相应图像。
% 模式3 表示无筛选的情况下，提取相应图像。
% 注意程序运行时会提示要求输入实验组！


%% 预处理
clear all;
close all;
clc;
diary off;
sp=actxserver('SAPI.SpVoice');


%% 用户输入初始参数 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Args.mode = '1' ; % 提取指定的文件和文件夹的模式，如简介所述。
Args.folderpath_EachImageBaseFolder = '.\data\resources\CV在不均匀图片上表现不好'; % 用于提取文件的结构体 EachImage 的基本路径
Args.folderpath_ResultsBaseFolder = '.\data\evaluation\CV在不均匀图片上表现不好'; % 用于提取文件的结构体 Results 的基本路径。
Args.folderpath_experiment = '.\data\evaluation\circleACMGMM 5-28挑出来\需要出中间运行结果的'; % 用于提取文件的结构体 Results 的基本路径。
Args.folderpath_outputBase = '.\data\extract\CV在不均匀图片上表现不好 筛'; % 提取文件的目标文件夹
Args.outputMode = 'datatime' ;	 % 指定存放这次实验的文件夹的文件名称显示类型。可选 'datatime' 'index'。'datatime' 表示实验文件夹名称是日期时间；'index'表示实验文件夹名称是编号。默认 'datatime'。推荐用默认值。
Args.num_scribble = 1; % 所有待处理的图像的标记总数。由于目前暂时不考虑不同标记对分割效果的影响，而仅仅用一张图像一种标记，因此目前手动设置为1。
Args.isVisual = 'no' ;  % 绘制过程不可视化，程序结束后自行查看结果。 'yes'表示绘制过程中可视化 ，'no'表示绘制过程中不可视化。默认'no'
Args.numUselessFiles = 0; % 要排除的图像数量。有时候存储图片的文件夹除了有图像文件，还有可能是系统文件会被误处理，因此需要手动排除。
Args.ratioOfGood = 0.7 ; % 定义好的图像的所占的指标的值的比例阈值。值域[0,1]，默认 0.85
Args.ratioOfBad = 0.5 ; % 定义差的图像的所占的指标的值的比例阈值。值域[0,1]，默认 0.65
Args.ratioOfBetter = 0.3 ; % 两种方法比较时，方法A要比方法B的指标的值的比例要大于等于该值，才认为明显好。值域[0,1]，默认 0.3
Args.ratioOfBetterAtBothGood = 0.001 ; % 两种方法比较时，两种方法都好的情况下，方法A要比方法B的指标的值的比例要大于等于该值，才认为明显好。值域[0,1]，默认0.1
Args.ratioOfRegion = 1.0; % 实验组和对照组比较时，实验组效果比对照组效果不好的图像数量 占 实验组效果比对照组效果好的图像数量 的比例。
Args.ratioOfRand = 0.1; % 控制实验组和对照组比较时，实验组效果好的图像数量占总图像数量的比例的随机范围。
Args.ratioImagesShow = 1.0 ; % 要提取的图像的最大限制比例。值域[0,1]，默认0.1。

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% properties
Pros = Args;

%% 构建文件夹的资源resources 结构体EachImage，构建results文件夹里指定做的指标的文件路径和名称的结构体 Results
EachImage = createEachImageStructure(Pros.folderpath_EachImageBaseFolder ,Pros.numUselessFiles);
% EachImage_output = createEachImageStructure(Pros.folderpath_experiment ,Pros.numUselessFiles);
Results = createResultsStructure(Pros.folderpath_ResultsBaseFolder ,Pros.numUselessFiles);
% Results_output = createResultsStructure(Pros.folderpath_experiment, Pros.numUselessFiles);

% Pros.indexOfScribbledImageFolder = findIndexOfFolderName(EachImage, 'scribbled images');
% Pros.indexOfOriginalImageFolder = findIndexOfFolderName(EachImage, 'original images');
% Pros.indexOfBwDataFolder = findIndexOfFolderName(EachImage, 'bw data');
% Pros.indexOfBwImagesFolder = findIndexOfFolderName(EachImage, 'bw images');
% Pros.indexOfGTFolder = findIndexOfFolderName(EachImage, 'ground truth images');
% Pros.indexOfEvaluationsFolder = findIndexOfFolderName(EachImage, 'evaluations');
% Pros.indexOfFiguresFolder = findIndexOfFolderName(EachImage, 'figures');
%

%% 设置实验组：
Args.experiment = input('确认文件夹里的文件数量是否正确？正确的话输入编号指定实验组，并继续，否则按 Ctrl+c 终止程序。')
Pros = Args;

%% 构建文件夹
switch Args.outputMode
	case 'datatime'
		% 建立一个名称为年月日时分秒的数据文件夹用于每一次的实验的输出
		Pros.foldername_experiment=[datestr(now,'dd-HHMMSS') '_evaluationAnalyse'];
	case 'index'
		Pros.foldername_experiment = ['第' num2str(index_experiment) '次实验'];
end
Pros.folderpath_experiment=fullfile(Pros.folderpath_outputBase, Pros.foldername_experiment);
mkdir(Pros.folderpath_experiment);

% properties
Pros.num_scribble =1; % 标记的数量。目前不考虑不同的标记对实验结果的影响，因此设置为1
% 要处理的图像数量。有时候存储图片的文件夹除了有图像文件，还有可能是系统文件会被误处理，因此需要手动排除
Pros.num_image = EachImage.num_groundTruthBwImage;
Pros.num_experiments = Results.num_experiments;

%% 记录日志
% 生成diary输出文件夹
Pros.filename_diary = 'diary evaluation analyse.txt';
Pros.filepath_diary = fullfile(Pros.folderpath_experiment, Pros.filename_diary);
diary(Pros.filepath_diary);
diary on;
Args


%% 计时
tic;

switch Pros.mode
	case '1'
		
		%% 打印
		disp(['定义好的图像的所占的指标的值的比例阈值：' num2str(Pros.ratioOfGood)])
		disp(['定义差的图像的所占的指标的值的比例阈值：' num2str(Pros.ratioOfBad)])
		disp(['两种方法比较时，方法A要比方法B的指标的值的比例要大于等于该值，才认为明显好。该值设置为：' num2str(Pros.ratioOfBetter)])
		disp(['两种方法比较时，两种方法都好的情况下，方法A要比方法B的指标的值的比例要大于等于该值，才认为明显好。该值设置为：' num2str(Pros.ratioOfBetterAtBothGood)])
		disp(['实验组和对照组比较时，实验组效果好的图像数量占总图像数量的比例。该值设置为：' num2str(Pros.ratioOfRegion)])
		disp(['控制实验组和对照组比较时，实验组效果好的图像数量占总图像数量的比例的随机范围。该值设置为：' num2str(Pros.ratioOfRand)])
		
		%%
		iterationIndicator=zeros(Pros.num_image,Pros.num_experiments);
		for i=1:Pros.num_experiments
			% 			filenameStr = '_Jaccard_compareTwo' ;
			load(fullfile(Results.experiments(i).folderpath_evaluationData, 'time.mat'));
			iterationIndicator(:,i)=elipsedEachTime.iteration;
			clear elipsedEachTime;
		end
		labelStr_iteration = 'iteration';
		ceilValue_iteration = max(iterationIndicator(:));
		isReverseAxes_iteration = 'yes';
		
		timeIndicator=zeros(Pros.num_image,Pros.num_experiments);
		for i=1:Pros.num_experiments
			% 			filenameStr = '_Jaccard_compareTwo' ;
			load(fullfile(Results.experiments(i).folderpath_evaluationData, 'time.mat'));
			timeIndicator(:,i)=elipsedEachTime.time;
			clear elipsedEachTime;
		end
		labelStr_time = 'time';
		ceilValue_time = max(timeIndicator(:));
		isReverseAxes_time = 'yes';
		
		%%
% 		[indexes] = findIndexOfExistOriginalImage(Pros.folderpath_experiment, EachImage_ref);
		
		%% 在 Iteration 指标下，实验组效果好，对照组效果较差的图像
		% 获取符合条件的图像索引
		images1better_iteration(:,1)=find(iterationIndicator(:,Pros.experiment)<=mean(iterationIndicator(:,Pros.experiment),1));
		array_experiments = 1:Results.num_experiments;
		array_experiments(Pros.experiment)=[];
		for i=array_experiments
			temp1(:,1)=find( (iterationIndicator(:,i)>=mean(iterationIndicator(:,i))) & (iterationIndicator(:,Pros.experiment)<=iterationIndicator(:,i))  );
			temp2(:,1) = intersect(images1better_iteration, temp1);
			images1better_iteration=temp2;
			clear temp1 temp2;
		end
		% 生成符合条件的图像集合构成的新的Iteration矩阵。
		for i=1:Pros.num_experiments
			images1better_iteration(:,i+1) = iterationIndicator(images1better_iteration(:,1),i);
		end
		% 获取符合条件的图像数量
		num_images1better_iteration=size(images1better_iteration,1);
		% 提取满足 Iteration 条件的相关图像
		randInterger1 = randperm(size(images1better_iteration,1),ceil(Pros.ratioImagesShow*num_images1better_iteration));
		imagesNeed=images1better_iteration(randInterger1,1);
		num_imagesNeeded = size(imagesNeed,1);
		
		% collect 收集需要的图像到指定的文件夹
		folderpath_images_iteration = fullfile(Pros.folderpath_experiment, 'iter');
		if ~exist(folderpath_images_iteration,'dir')
			mkdir(folderpath_images_iteration);
		end
		for i=1:num_imagesNeeded
			copyfile(EachImage.originalImage(imagesNeed(i)).path, folderpath_images_iteration);
			% 			copyfile(EachImage.groundTruthBwImage(imagesNeed(i)).path, folderpath_images);
			% 			copyfile(EachImage.contourImage(imagesNeed(i)).path, folderpath_images);
			% 			copyfile(EachImage.scribbledImage(imagesNeed(i)).path, folderpath_images);
		end
		
		%% 在 Time 指标下，实验组效果好，对照组效果较差的图像
		% 获取符合条件的图像索引
		images1better_time(:,1)=find(timeIndicator(:,Pros.experiment)<=mean(timeIndicator(:,Pros.experiment)));
		array_experiments = 1:Results.num_experiments;
		array_experiments(Pros.experiment)=[];
		for i=array_experiments
			temp1(:,1)=find( (timeIndicator(:,i)>=mean(timeIndicator(:,i))) & (timeIndicator(:,Pros.experiment)<=timeIndicator(:,i))  );
			temp2(:,1) = intersect(images1better_time, temp1);
			images1better_time=temp2;
			clear temp1 temp2;
		end
		% 生成符合条件的图像集合构成的新的Iteration矩阵。
		for i=1:Pros.num_experiments
			images1better_time(:,i+1) = timeIndicator(images1better_time(:,1),i);
		end
		% 获取符合条件的图像数量
		num_images1better_time=size(images1better_time,1);
		% 提取满足 Time 条件的相关图像
		randInterger1 = randperm(size(images1better_time,1),ceil(Pros.ratioImagesShow*num_images1better_time));
		imagesNeed=images1better_time(randInterger1,1);
		num_imagesNeeded = size(imagesNeed,1);
		
		% collect 收集需要的图像到指定的文件夹
		folderpath_images_time = fullfile(Pros.folderpath_experiment, 'time');
		if ~exist(folderpath_images_time,'dir')
			mkdir(folderpath_images_time);
		end
		for i=1:num_imagesNeeded
			copyfile(EachImage.originalImage(imagesNeed(i)).path, folderpath_images_time);
			% 			copyfile(EachImage.groundTruthBwImage(imagesNeed(i)).path, folderpath_images);
			% 			copyfile(EachImage.contourImage(imagesNeed(i)).path, folderpath_images);
			% 			copyfile(EachImage.scribbledImage(imagesNeed(i)).path, folderpath_images);
		end
		
		
		
	case '2'
		
		
	case '3'
		%% 提取相关图像
		% 提取相关图像并重命名文件名以方便用户筛选
		
		folderpath_images = Pros.folderpath_experiment;
		if ~exist(folderpath_images,'dir')
			mkdir(folderpath_images);
		end
		
		for index_image=1:Pros.num_image
			% extracting original image
			copyfile(EachImage.originalImage(index_image).path, fullfile(folderpath_images, EachImage.originalImage(index_image).name));
			% extracting ground truth image
			filename_newImg = [EachImage.originalImage(index_image).name(1:end-4) '_init.bmp'];
			copyfile(EachImage.contourImage(index_image).path, fullfile(folderpath_images, filename_newImg));
			% extracting initalized contour
			filename_newImg = [EachImage.originalImage(index_image).name(1:end-4) '_gt.bmp'];
			copyfile(EachImage.groundTruthBwImage(index_image).path, fullfile(folderpath_images, filename_newImg));
			% extracting bw-image of each methods
			for index_experiment = 1:Pros.num_experiments
				filename_newImg = [EachImage.originalImage(index_image).name(1:end-4) '_' Results.experiments(index_experiment).name '.bmp'];
				copyfile(Results.experiments(index_experiment).bwImages(index_image).path, fullfile(folderpath_images, filename_newImg));
			end
			
			
% 			% 如果需要中间结果的话，可以启用这段代码【
% 			for index_experiment = 1:Pros.num_experiments
% 							filename_newImg = [EachImage.originalImage(index_image).name(1:end-4) '_' Results_final.experiments(index_experiment).name '.bmp'];
% 				copyfile(Results_final.experiments(index_experiment).bwImages(index_image).path, fullfile(folderpath_images, filename_newImg));
% 			end
% 			% 】
		end
		
		
	otherwise
		error('error at choose mode');
end


%%
diary off;
toc;
text=['程序运行完毕。'];
disp(text)
sp.Speak(text);
