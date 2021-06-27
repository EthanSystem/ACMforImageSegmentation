function [ Results ] = createResultsStructureForVisualization( baseFolder, numUselessFiles )
%createResultsStructure 此处显示有关此函数的摘要
%   input:
% numUselessFiles：要减去的无用的文件数。针对Windows系统的图像文件夹里的文件“Thumbs.db”
% output:
% Results：返回一个结构体

%% 构建results文件夹里指定做的指标的文件路径和名称的结构体 Results
Results.folderpath_outputBase = [ baseFolder ];
Results.experiments=dir(Results.folderpath_outputBase);	% 每次实验的文件夹列表
Results.experiments(1:2,:)=[]; 
% % 获取指定要处理的实验文件夹的索引值
% index_experiment = findIndexOfExprimentFolder(Results.experiments, Pros.foldername);

Results.num_experiments=numel(Results.experiments);
if Results.num_experiments~=0
	for index_experiment=1:Results.num_experiments
		%% 指定实验的文件夹
		Results.experiments(index_experiment).path=fullfile(Results.folderpath_outputBase, Results.experiments(index_experiment).name);
% 		foldersInEachExperiments=dir(Results.experiments(index_experiment).path);
		
% 		%% 生成diary输出文件夹
% 		Results.experiments(index_experiment).diary.name = 'diary output';
% 		Results.experiments(index_experiment).diary.folderpath = fullfile(Results.experiments(index_experiment).path, Results.experiments(index_experiment).diary.name);
% 		mkdir(Results.experiments(index_experiment).diary.folderpath);
% 		if ~exist(Results.experiments(index_experiment).diary.folderpath,'dir')
% 			mkdir(Results.experiments(index_experiment).diary.folderpath);
% 		end
		
		%% 最终分割二值图截图文件夹路径
		Results.experiments(index_experiment).folderpath_bwImage = [Results.experiments(index_experiment).path];
		% 每个最终分割二值图截图名称和路径
		Results.experiments(index_experiment).bwImages= dir([Results.experiments(index_experiment).folderpath_bwImage '\*.bmp']);
		Results.experiments(index_experiment).num_bwImage = numel(Results.experiments(index_experiment).bwImages)-numUselessFiles;
		disp(['实验文件夹 ' Results.experiments(index_experiment).name ' 有 ' num2str(Results.experiments(index_experiment).num_bwImage) ' 个分割二值图文件'])
		if Results.experiments(index_experiment).num_bwImage ~=0
			for index_bwImage= 1:Results.experiments(index_experiment).num_bwImage
				Results.experiments(index_experiment).bwImages(index_bwImage).path = fullfile(Results.experiments(index_experiment).folderpath_bwImage, Results.experiments(index_experiment).bwImages(index_bwImage).name);
			end
		else
			disp(['文件夹 ' Results.experiments(index_experiment).folderpath_bwImage ' 没有分割二值图文件...']);
		end
		
% 		%% 最终分割二值数据文件夹路径
% 		Results.experiments(index_experiment).folderpath_bwData = fullfile(Results.experiments(index_experiment).path, 'bw data');
% 		if ~exist(Results.experiments(index_experiment).folderpath_bwData,'dir')
% 			mkdir(Results.experiments(index_experiment).folderpath_bwData);
% 		end
% 		% 每个最终分割二值数据名称和路径
% 		Results.experiments(index_experiment).bwData= dir([Results.experiments(index_experiment).folderpath_bwData '\*.mat']);
% 		Results.experiments(index_experiment).num_bwData = numel(Results.experiments(index_experiment).bwData)-numUselessFiles;
% 		disp(['实验文件夹 ' Results.experiments(index_experiment).name ' 的文件夹 bw data 有 ' num2str(Results.experiments(index_experiment).num_bwData) ' 个文件'])
% 		if Results.experiments(index_experiment).num_bwData ~=0
% 			for index_bwData= 1:Results.experiments(index_experiment).num_bwData
% 				Results.experiments(index_experiment).bwData(index_bwData).path = fullfile(Results.experiments(index_experiment).folderpath_bwData, Results.experiments(index_experiment).bwData(index_bwData).name);
% 			end
% 		else
% 			disp(['文件夹 ' Results.experiments(index_experiment).folderpath_bwImage ' 没有分割二值数据文件...']);
% 		end
		
% 		%% 最终嵌入函数文件夹路径
% 		Results.experiments(index_experiment).folderpath_phiData = fullfile(Results.experiments(index_experiment).path, 'phi data');
% 		if ~exist(Results.experiments(index_experiment).folderpath_phiData,'dir')
% 			mkdir(Results.experiments(index_experiment).folderpath_phiData);
% 		end
% 		% 每个最终嵌入函数名称和路径
% 		Results.experiments(index_experiment).phiData= dir([Results.experiments(index_experiment).folderpath_phiData '\*.mat']);
% 		Results.experiments(index_experiment).num_phiData = numel(Results.experiments(index_experiment).phiData);
% 		disp(['实验文件夹 ' Results.experiments(index_experiment).name ' 的文件夹 phi data 有 ' num2str(Results.experiments(index_experiment).num_phiData) ' 个文件'])
% 		if Results.experiments(index_experiment).num_phiData ~=0
% 			for index_phiData= 1:Results.experiments(index_experiment).num_phiData
% 				Results.experiments(index_experiment).bwImage(index_phiData).path = fullfile(Results.experiments(index_experiment).folderpath_phiData, Results.experiments(index_experiment).phiData(index_phiData).name);
% 			end
% 		else
% 			disp(['文件夹 ' Results.experiments(index_experiment).folderpath_bwImage ' 没有嵌入函数文件...']);
% 		end
		
% 		%% 标记图像的标记种子数据文件夹路径
% 		Results.experiments(index_experiment).folderpath_seeds = fullfile(Results.experiments(index_experiment).path, 'seeds data');
% 		if ~exist(Results.experiments(index_experiment).folderpath_seeds,'dir')
% 			mkdir(Results.experiments(index_experiment).folderpath_seeds);
% 		end
% 		% 每个标记图像的种子数据的名称和路径
% 		Results.experiments(index_experiment).seeds = dir([Results.experiments(index_experiment).folderpath_seeds '\*.mat']);
% 		Results.experiments(index_experiment).num_seeds = numel(Results.experiments(index_experiment).seeds);
% 		disp(['实验文件夹 ' Results.experiments(index_experiment).name ' 的文件夹 seeds data 有 ' num2str(Results.experiments(index_experiment).num_seeds) ' 个文件'])
% 		if Results.experiments(index_experiment).num_seeds ~=0
% 			for index_seeds = 1:Results.experiments(index_experiment).num_seeds
% 				Results.experiments(index_experiment).seeds(index_seeds).path = fullfile(Results.experiments(index_experiment).folderpath_seeds, Results.experiments(index_experiment).seeds(index_seeds).name);
% 			end
% 		else
% 			disp(['文件夹 ' Results.experiments(index_experiment).folderpath_seeds ' 没有标记种子文件...']);
% 		end
		
% 		%% 结果截图文件夹路径
% 		Results.experiments(index_experiment).folderpath_screenShot = fullfile(Results.experiments(index_experiment).path, 'screen shot');
% 		if ~exist(Results.experiments(index_experiment).folderpath_screenShot,'dir')
% 			mkdir(Results.experiments(index_experiment).folderpath_screenShot);
% 		end
% 		% 每个结果图的截图名称和路径
% 		Results.experiments(index_experiment).screenShot = dir([Results.experiments(index_experiment).folderpath_screenShot '\*.jpg']);
% 		Results.experiments(index_experiment).num_screenShot = numel(Results.experiments(index_experiment).screenShot)-numUselessFiles;
% 		disp(['实验文件夹 ' Results.experiments(index_experiment).name ' 的文件夹 screen shot 有 ' num2str(Results.experiments(index_experiment).num_screenShot) ' 个文件'])
% 		if Results.experiments(index_experiment).num_screenShot ~=0
% 			for index_screenShot = 1:Results.experiments(index_experiment).num_screenShot
% 				Results.experiments(index_experiment).screenShot(index_screenShot).path = fullfile(Results.experiments(index_experiment).folderpath_screenShot, Results.experiments(index_experiment).screenShot(index_screenShot).name);
% 			end
% 		else
% 			disp(['文件夹 ' Results.experiments(index_experiment).folderpath_screenShot ' 没有结果图文件...']);
% 		end
		
% 		%% 输出数据文件夹路径
% 		Results.experiments(index_experiment).folderpath_writeData = fullfile(Results.experiments(index_experiment).path, 'write data');
% 		if ~exist(Results.experiments(index_experiment).folderpath_writeData,'dir')
% 			mkdir(Results.experiments(index_experiment).folderpath_writeData);
% 		end
% 		% 每个输出数据文件名称和路径
% 		Results.experiments(index_experiment).writeData = dir([Results.experiments(index_experiment).folderpath_writeData '\*.mat']);
% 		Results.experiments(index_experiment).num_writeData = numel(Results.experiments(index_experiment).writeData );
% 		disp(['实验文件夹 ' Results.experiments(index_experiment).name ' 的文件夹 write data 有 ' num2str(Results.experiments(index_experiment).num_writeData) ' 个文件'])
% 		if Results.experiments(index_experiment).num_writeData ~=0
% 			for index_writeData = 1:Results.experiments(index_experiment).num_writeData
% 				Results.experiments(index_experiment).writeData(index_writeData).path = fullfile(Results.experiments(index_experiment).folderpath_writeData, Results.experiments(index_experiment).writeData(index_writeData).name);
% 			end
% 		else
% 			disp(['文件夹 ' Results.experiments(index_experiment).folderpath_writeData ' 没有输出数据文件...']);
% 		end
		
		
% 		%% 输出评价值数据的文件夹路径
% 		Results.experiments(index_experiment).folderpath_evaluationData = fullfile(Results.experiments(index_experiment).path, 'evaluation data');
% 		if ~exist(Results.experiments(index_experiment).folderpath_evaluationData,'dir')
% 			mkdir(Results.experiments(index_experiment).folderpath_evaluationData);
% 		end
% 		Results.experiments(index_experiment).evaluationData = dir([Results.experiments(index_experiment).folderpath_evaluationData '\*.mat']);
% 		Results.experiments(index_experiment).num_evaluationData = numel(Results.experiments(index_experiment).evaluationData );
% 		disp(['实验文件夹 ' Results.experiments(index_experiment).name ' 的文件夹 evaluation data 有 ' num2str(Results.experiments(index_experiment).num_evaluationData) ' 个文件'])
% 		if Results.experiments(index_experiment).num_evaluationData ~=0
% 			for index_evaluationData = 1:Results.experiments(index_experiment).num_evaluationData
% 				Results.experiments(index_experiment).evaluationData(index_evaluationData).path = fullfile(Results.experiments(index_experiment).folderpath_evaluationData, Results.experiments(index_experiment).evaluationData(index_evaluationData).name);
% 			end
% 		else
% 			disp(['文件夹 ' Results.experiments(index_experiment).folderpath_writeData ' 没有输出数据文件...']);
% 		end
		
		
		
	end % end experiment loop
	
end % end if

end

