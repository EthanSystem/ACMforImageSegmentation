%% 简介
% evaluationAnalyse.m 实现对评价指标的各种分析和可视化

%% 预处理
clear all;
close all;
clc;
diary off;
sp=actxserver('SAPI.SpVoice');


%% 用户输入初始参数 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Args.evolutionAnalyseMode = '2' ;  % 分析模式。'1' 表示两个算法比较分析；'2' 表示所有方法一起分析。
Args.ImageSetMode = '1' ; % 待分析的数据集的排列类型。'1' 表示从Results标准文件排放方式提取数据做分析； ‘2’ 表示从原图、真值图、各方法二值图所在的唯一一个文件夹里面提取数据作分析。

Args.folderpath_reourcesDatasets = '.\data\expr2_analysis_semiACMGMM_毕业论文有歧义的图片\original resources';  % 基础资源文件（原图、真值图、标记图）的基本路径
% 其实 folderpath_initBaseFolder 在计算指标的时候不重要，随便设置一个就可以了。
Args.folderpath_initBaseFolder = '.\data\expr2_analysis_semiACMGMM_毕业论文有歧义的图片\init resources';  % 基础初始化文件（各种初始化方法生成的如初始轮廓二值图、各参数、时间参数等）的基本路径
Args.folderpath_ResultsBaseFolder = '.\data\expr2_analysis_semiACMGMM_毕业论文有歧义的图片\evaluation'; % 用于计算文件的结构体 Results 的基本路径。
Args.folderpath_outputBase = '.\data\expr2_analysis_semiACMGMM_毕业论文有歧义的图片\analysis'; % 用于输出可视化结果的基本路径

% Args.folderpath_reourcesDatasets = '.\data\expr1_analysis_ACMGMM_原来论文的图\original resources';  % 基础资源文件（原图、真值图、标记图）的基本路径
% % 其实 folderpath_initBaseFolder 在计算指标的时候不重要，随便设置一个就可以了。
% Args.folderpath_initBaseFolder = '.\data\expr1_analysis_ACMGMM_原来论文的图\init resources';  % 基础初始化文件（各种初始化方法生成的如初始轮廓二值图、各参数、时间参数等）的基本路径
% Args.folderpath_ResultsBaseFolder = '.\data\expr1_analysis_ACMGMM_原来论文的图\evaluation'; % 用于计算文件的结构体 Results 的基本路径。
% Args.folderpath_outputBase = '.\data\expr1_analysis_ACMGMM_原来论文的图\analysis'; % 用于输出可视化结果的基本路径

Args.outputMode = 'datatime';	 % 指定存放这次实验的文件夹的文件名称显示类型。可选 'datatime' 'index'。'datatime' 表示实验文件夹名称是日期时间；'index'表示实验文件夹名称是编号。默认 'datatime'。推荐用默认值。
Args.num_scribble = 1; % 所有待处理的图像的标记总数。由于目前暂时不考虑不同标记对分割效果的影响，而仅仅用一张图像一种标记，因此目前手动设置为1。
Args.isVisual = 'no' ;  % 绘制过程不可视化，程序结束后自行查看结果。 'yes'表示绘制过程中可视化 ，'no'表示绘制过程中不可视化。默认'no'
Args.numUselessFiles = 0; % 要排除的图像数量。有时候存储图片的文件夹除了有图像文件，还有可能是系统文件会被误处理，因此需要手动排除。
Args.ratioOfGood = 0.75 ; % 定义好的图像的所占的指标的值的比例阈值。值域[0,1]，默认 0.85
Args.ratioOfBad = 0.60 ; % 定义差的图像的所占的指标的值的比例阈值。值域[0,1]，默认 0.65
Args.ratioOfBetter = 0.01 ; % 两种方法比较时，方法A要比方法B的指标的值的比例要大于等于该值，才认为明显好。值域[0,1]，默认 0.3
Args.ratioOfBetterAtBothGood = 0.01 ; % 两种方法比较时，两种方法都好的情况下，方法A要比方法B的指标的值的比例要大于等于该值，才认为明显好。值域[0,1]，默认0.1
Args.numImagesShow = 20 ;
Args.lineWidth = 1;
Args.markerSize = 3;
Args.figSize = [1000 300];

% 用于 evolutionAnalyseMode = '1'
% 实验组是1、对照组是2：
Args.experiment01 = 1 ;
Args.experiment02 = 2 ;

% 用于 evolutionAnalyseMode = '2'
% 按照给定的Restuls的排序自行排序哪个方法先绘制，那个方法后绘制。
% 绘制过程中如果出现线条叠加的情况下，后绘制的线条容易覆盖先绘制的线条。因此，一般考虑让需要突出显示的实验组后绘制。
Args.experimentSequence = [2 1]; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% properties
Pros = Args;


%% 构建文件夹的资源resources 结构体EachImage，构建results文件夹里指定做的指标的文件路径和名称的结构体 Results
EachImage_ref = createEachImageStructure(Pros.folderpath_reourcesDatasets, Pros.folderpath_initBaseFolder, Pros.numUselessFiles);
Results_ref = createResultsStructure(Pros.folderpath_ResultsBaseFolder, Pros.numUselessFiles);
EachImage = createEachImageStructure(Pros.folderpath_reourcesDatasets, Pros.folderpath_initBaseFolder, Pros.numUselessFiles);
Results = createResultsStructure(Pros.folderpath_ResultsBaseFolder, Pros.numUselessFiles);


input('确认文件夹里的文件数量是否正确？正确按任意键继续，否则按 Ctrl+c 终止程序。')






%% 构建本次评价的可视化的文件夹，并进行可视化
switch Args.outputMode
	case 'datatime'
		% 建立一个名称为年月日时分秒的数据文件夹用于每一次的实验的输出
		Pros.foldername_experiment=['evaluation' '_' datestr(now,'ddHHMMSS')];
	case 'index'
		Pros.foldername_experiment = ['第' num2str(index_experiment) '次实验'];
end
Pros.folderpath_experiment=fullfile(Pros.folderpath_outputBase, Pros.foldername_experiment);
% Pros.folderpath_experiment=Pros.folderpath_outputBase;
mkdir(Pros.folderpath_experiment);

% properties
Pros.num_scribble =1; % 标记的数量。目前不考虑不同的标记对实验结果的影响，因此设置为1
% 要处理的图像数量。有时候存储图片的文件夹除了有图像文件，还有可能是系统文件会被误处理，因此需要手动排除
Pros.num_image = EachImage_ref.num_groundTruthBwImage;

%% 记录日志
% 生成diary输出文件夹
Pros.filename_diary = 'diary evaluation analyse.txt';
Pros.filepath_diary = fullfile(Pros.folderpath_experiment, Pros.filename_diary);
diary(Pros.filepath_diary);
diary on;

%% 计时
tic;

%% 打印
disp(['定义好的图像的所占的指标的值的比例阈值 = ' num2str(Pros.ratioOfGood)])
disp(['定义差的图像的所占的指标的值的比例阈值 = ' num2str(Pros.ratioOfBad)])
disp(['两种方法比较时，方法A要比方法B的指标的值的比例要大于等于该值，才认为明显好。该值设置为 = ' num2str(Pros.ratioOfBetter)])
disp(['两种方法比较时，两种方法都好的情况下，方法A要比方法B的指标的值的比例要大于等于该值，才认为明显好。该值设置为 = ' num2str(Pros.ratioOfBetterAtBothGood)])

%%
switch Pros.evolutionAnalyseMode
	case '1'
		%% 统计两种分割方法处理图像的关于图像数量的属性，找出一组最好的图像集合。
		switch Pros.ImageSetMode
			case '1'
				evaluation_statistic('Jaccard', Pros, EachImage_ref, Results_ref, Pros.experiment01, Pros.experiment02);
				evaluation_statistic('ModifiedHausdorff', Pros, EachImage_ref, Results_ref, Pros.experiment01, Pros.experiment02);
				evaluation_statistic('F1', Pros, EachImage_ref, Results_ref, Pros.experiment01, Pros.experiment02);
				
				%% 对比两种方法得到散点分布图
				visualizeCompareTwoMethod('Jaccard', Pros, EachImage_ref, Results_ref, Pros.experiment01, Pros.experiment02, Pros.isVisual);
				visualizeCompareTwoMethod('ModifiedHausdorff', Pros, EachImage_ref, Results_ref, Pros.experiment01, Pros.experiment02, Pros.isVisual);
				visualizeCompareTwoMethod('F1', Pros, EachImage_ref, Results_ref, Pros.experiment01, Pros.experiment02, Pros.isVisual);
				
				
				%% 比较macro-F1的值
				load(Results_ref.experiments(Pros.experiment01).evaluationData(3).path);
				macroF1_1=macroF1;
				load(Results_ref.experiments(Pros.experiment02).evaluationData(3).path);
				macroF1_2=macroF1;
				disp(['方法 ' Results_ref.experiments(Pros.experiment01).name ' 的 macro-F1 指标的值是：' num2str(macroF1_1)])
				disp(['方法 ' Results_ref.experiments(Pros.experiment02).name ' 的 macro-F1 指标的值是：' num2str(macroF1_2)])
			case '2'
				
			otherwise
				error('error at choose mode !')
		end
	case '2'
		%% 可视化指标
		switch Pros.ImageSetMode
			case '1'
				visualizeIndicator('Jaccard', Pros, Results_ref, Pros.num_image, Pros.num_scribble, Results_ref.num_experiments, Pros.isVisual, Pros.experimentSequence);
				visualizeIndicator('ModifiedHausdorff', Pros, Results_ref ,Pros.num_image, Pros.num_scribble, Results_ref.num_experiments, Pros.isVisual, Pros.experimentSequence);
				visualizeIndicator('F1', Pros, Results_ref, Pros.num_image, Pros.num_scribble, Results_ref.num_experiments, Pros.isVisual, Pros.experimentSequence);
				visualizeIndicator('macro-F1', Pros, Results_ref, Pros.num_image, Pros.num_scribble, Results_ref.num_experiments, Pros.isVisual, Pros.experimentSequence);
				visualizeIndicator('time', Pros, Results_ref, Pros.num_image, Pros.num_scribble, Results_ref.num_experiments, Pros.isVisual, Pros.experimentSequence);
				visualizeIndicator('iteration', Pros, Results_ref, Pros.num_image, Pros.num_scribble, Results_ref.num_experiments, Pros.isVisual, Pros.experimentSequence);
				
				
				%% 生成论文用的图像阵列图
				%         visualizeBwImageForPaper( Pros, EachImage, Results, Pros.isVisual);
			case '2'
				disp(['method        time        iteration'])
				for idx_method=1:Results_ref.num_experiments
					load(fullfile(Results_ref.experiments(idx_method).folderpath_evaluationData, 'time.mat'));
					meanTime = mean(elipsedEachTime.time);
					meanIteration = mean(elipsedEachTime.iteration);
					disp([Results_ref.experiments(idx_method).name '        ' num2str(meanTime) '        ' num2str(meanIteration)]);
				end
				
			otherwise
				error('error at choose mode !')
		end
		
		%% 计算和输出 各个方法的平均时间和平均迭代次数
		
		
		
		
	otherwise
		disp(['error at choose mode !']);
end
%%
diary off;
toc;
text=['程序运行完毕。'];
disp(text)
sp.Speak(text);





