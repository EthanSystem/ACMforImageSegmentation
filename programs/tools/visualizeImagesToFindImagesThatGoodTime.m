%% 简介
% visualizeImagesToFindImagesThatGoodTime.m 可视化，寻找合适的图像，体现我们的迭代收敛快的。
% mode = '1' 表示每种方法的各个图像的二值图集中展示；
% mode = '2' 表示每一行表示一组图像，每组图像有原图、真值图、各方法的二值图；
% mode = '3' 是 mode = '2' 的转置；
% mode = '4' 和 ‘2’ 类似，但是是紧凑排布。
% mode = '5' 和 ‘3’ 类似，但是是紧凑排布。

%% 预处理
clear all;
close all;
clc;
diary off;
sp=actxserver('SAPI.SpVoice');


%% 用户输入初始参数 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Args.mode = '1' ; % mode = '1' 表示每种方法的各个图像的二值图集中展示，mode = '2' 表示每一行表示一组图像，每组图像有原图、真值图、各方法的二值图
Args.labelStr = 'JD';
Args.folderpath_EachImageBaseFolder = '.\data\resources\比较同一代数'; % 用于计算文件的结构体 EachImage 的基本路径
Args.folderpath_ResultsBaseFolder = '.\data\segmentations\比较同一代数'; % 用于计算文件的结构体 Results 的基本路径。
Args.folderpath_outputBase = '.\data\exportForPaper\比较同一代数'; % 指定用于输出的文件夹的基本路径。
Args.outputMode = 'datatime';	 % 指定存放这次实验的文件夹的文件名称显示类型。可选 'datatime' 'index'。'datatime' 表示实验文件夹名称是日期时间；'index'表示实验文件夹名称是编号。默认 'datatime'。推荐用默认值。Args.num_scribble = 1; % 所有待处理的图像的标记总数。由于目前暂时不考虑不同标记对分割效果的影响，而仅仅用一张图像一种标记，因此目前手动设置为1。
Args.isVisual = 'off' ;  % 绘制过程不可视化，程序结束后自行查看结果。 'on'表示绘制过程中可视化 ，'off'表示绘制过程中不可视化。默认'off'
Args.numUselessFiles = 0; % 要处理的图像数量。有时候存储图片的文件夹除了有图像文件，还有可能是系统文件会被误处理，因此需要手动排除。
Args.numImagesShow = 10; % 每张fig要展示的图像组的数量。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% properties
Pros = Args;

%% 构建文件夹的资源resources 结构体EachImage，构建results文件夹里指定做的指标的文件路径和名称的结构体 Results
EachImage = createEachImageStructure(Pros.folderpath_EachImageBaseFolder, Pros.numUselessFiles);
Results = createResultsStructure(Pros.folderpath_ResultsBaseFolder, Pros.numUselessFiles);

% Pros.indexOfScribbledImageFolder = findIndexOfFolderName(EachImage, 'scribbled images');
% Pros.indexOfOriginalImageFolder = findIndexOfFolderName(EachImage, 'original images');
% Pros.indexOfBwDataFolder = findIndexOfFolderName(EachImage, 'bw data');
% Pros.indexOfBwImagesFolder = findIndexOfFolderName(EachImage, 'bw images');
% Pros.indexOfGTFolder = findIndexOfFolderName(EachImage, 'ground truth images');
% Pros.indexOfEvaluationsFolder = findIndexOfFolderName(EachImage, 'evaluations');
% Pros.indexOfFiguresFolder = findIndexOfFolderName(EachImage, 'figures');

input('确认文件夹里的文件数量是否正确？正确按任意键继续，否则按 Ctrl+c 终止程序。')

%% 构建本次评价的可视化的文件夹，并进行可视化
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
% 要处理的原始图像数量。有时候存储图片的文件夹除了有图像文件，还有可能是系统文件会被误处理，因此需要手动排除
Pros.num_originalImage = EachImage.num_originalImage;
Pros.num_experiments = Results.num_experiments;


% 
% %% 记录日志
% % 生成diary输出文件夹
% Pros.filename_diary = 'diary evaluation analyse.txt';
% Pros.filepath_diary = fullfile(Pros.folderpath_experiment, Pros.filename_diary);
% diary(Pros.filepath_diary);
% diary on;


%% 计时
tic;

%%


switch Pros.mode
	case '1'
		%% 列举数据里对应的图像（论文用_1）
		% 		figure010 = figure('Name',[num2str(Pros.numImagesShow) ' 张筛选的图像在 ' labelStr ' 指标下的阵列图'],'Position',[20 20 2000 600],'Visible',controlVis);
		col=Results.num_experiments;
		for index_image = 1:EachImage.num_originalImage
			for index_method = 1:col
				load(Results.experiments(index_method).evaluationData.path);
				num_iter(index_image,index_method) = elipsedEachTime.iteration(index_image);
				clear elipsedEachTime;
			end
		end
		[min_iter,idx_min_iter]=min(num_iter,[],2);
		[max_iter,idx_max_iter]=max(num_iter,[],2);
		restMinrow = zeros(EachImage.num_originalImage, Results.num_experiments);
		for index_image = 1:EachImage.num_originalImage
			restMinrow(index_image,idx_max_iter(index_image))= max_iter(index_image)-min_iter(index_image);
		end
		
		row=min_iter+3; % 其中 3 表示原图、真值图、初始轮廓图
		index_bwData = ones(1,col);
		
		for index_image = 1:EachImage.num_originalImage
			% 			figure010 = figure('Name',[EachImage.originalImage(index_image).path ' 在不同方法的代数收敛情况对比图'],'Position',[20 20 400*col 400*row],'Visible',Pros.isVisual);
			figure010 = figure('Name',[EachImage.originalImage(index_image).name ' 在不同方法的代数收敛情况对比图'],'Position',[20 20 400*col 400*num_iter(index_image,index_method)],'Visible',Pros.isVisual);
			index_fig = 1;
			% original image
			for index_method=1:col
				subplot(row(index_image),col,index_fig);
				image010 = imread(EachImage.originalImage(index_image).path);
				[height_image, width_image, numVar ] = size(image010);
				imshow(image010);
				% 				axis equal;
				axis off;
				% 				title(strrep(EachImage.originalImage(index_image).name,'_','\_'));
				index_fig = index_fig+1;
			end
			
			% gt image
			for index_method=1:col
				subplot(row(index_image),col,index_fig);
				image010 = imread(EachImage.groundTruthBwImage(index_image).path);
				imshow(image010);
				% 				axis equal;
				axis off;
				% 				title(['gt ' Results.experiments(index_method).name]);
				% 				title(['gt']);
				index_fig = index_fig+1;
			end
			
			% initial contour image
			for index_method=1:col
				subplot(row(index_image),col,index_fig);
				image010 = imread(EachImage.contourImage(index_image).path);
				imshow(image010);
				% 				axis equal;
				axis off;
				% 				title(['final bw ' Results.experiments(index_method).name]);
				% 				title(['final bw']);
				index_fig = index_fig+1;
			end
			
			% iter bw image
			for index_row = 1:min_iter(index_image)
				for index_method=1:col
					subplot(row(index_image),col,index_fig);
					imageData = load(Results.experiments(index_method).bwData(index_bwData(index_method)).path);
					image010 = reshape(imageData.bwData, height_image, width_image);
					imshow(image010);
					% 					axis equal;
					axis off;
					% 					title(['iter ' num2str(index_row)]);
					index_fig = index_fig+1;
					index_bwData(index_method) = index_bwData(index_method)+1;
				end
			end
			for index_method=1:col
				index_bwData(index_method)=index_bwData(index_method)+restMinrow(index_image,index_method);
			end
			
			% save figure
			filename_figure = [EachImage.originalImage(index_image).name ' 在不同方法的代数收敛情况对比图.jpg'];
			filepath_figure = fullfile(Pros.folderpath_experiment, filename_figure);
			saveas(figure010,filepath_figure);
			
			
		end % end for index_figure
		
		
	case '2'
		%% 列举数据里对应的图像（论文用_2）
		col=Results.num_experiments;
		for index_image = 1:EachImage.num_originalImage
			for index_method = 1:col
				load(Results.experiments(index_method).evaluationData.path);
				num_iter(index_image,index_method) = elipsedEachTime.iteration(index_image); % 其中 2 表示原图和真值图
				clear elipsedEachTime;
			end
		end
		[min_iter,idx_min_iter]=min(num_iter,[],2);
		[max_iter,idx_max_iter]=max(num_iter,[],2);
		restMinrow = zeros(EachImage.num_originalImage, Results.num_experiments);
		for index_image = 1:EachImage.num_originalImage
			restMinrow(index_image,idx_max_iter(index_image))= max_iter(index_image)-min_iter(index_image);
		end
		
		index_bwData = ones(1,col);
		for index_image = 1:EachImage.num_originalImage
			% 			figure010 = figure('Name',[EachImage.originalImage(index_image).path ' 在不同方法的代数收敛情况对比图'],'Position',[20 20 400*col 400*row],'Visible',Pros.isVisual);
			figure010 = figure('Name',[EachImage.originalImage(index_image).name ' 在不同方法的代数收敛情况对比图'],'Position',[20 20 400*col 400*num_iter(index_image,index_method)],'Visible',Pros.isVisual);
			index_fig = 1;
			% original image
			for index_method=1:col
				subplot(min_iter(index_image),col,index_fig);
				image010 = imread(EachImage.originalImage(index_image).path);
				[height_image, width_image, numVar ] = size(image010);
				imshow(image010);
				% 				axis equal;
				axis off;
				% 				title(strrep(EachImage.originalImage(index_image).name,'_','\_'));
				index_fig = index_fig+1;
			end
			
			% gt image
			for index_method=1:col
				subplot(min_iter(index_image),col,index_fig);
				image010 = imread(EachImage.groundTruthBwImage(index_image).path);
				imshow(image010);
				% 				axis equal;
				axis off;
				% 				title(['gt ' Results.experiments(index_method).name]);
				% 				title(['gt']);
				index_fig = index_fig+1;
			end
			
			% final bw image
			for index_method=1:col
				subplot(min_iter(index_image),col,index_fig);
				image010 = imread(Results.experiments(index_method).bwImage(index_image).path);
				imshow(image010);
				% 				axis equal;
				axis off;
				% 				title(['final bw ' Results.experiments(index_method).name]);
				% 				title(['final bw']);
				index_fig = index_fig+1;
			end
			
			% iter bw image
			for index_row = 1:min_iter(index_image)
				for index_method=1:col
					subplot(min_iter(index_image),col,index_fig);
					imageData = load(Results.experiments(index_method).bwData(index_bwData(index_method)).path);
					image010 = reshape(imageData.bwData, height_image, width_image);
					imshow(image010);
					% 					axis equal;
					axis off;
					% 					title(['iter ' num2str(index_row)]);
					index_fig = index_fig+1;
					index_bwData(index_method) = index_bwData(index_method)+1;
				end
			end
			for index_method=1:col
				index_bwData(index_method)=index_bwData(index_method)+restMinrow(index_image,index_method);
			end
			
			% save figure
			filename_figure = [EachImage.originalImage(index_image).name ' 在不同方法的代数收敛情况对比图.jpg'];
			filepath_figure = fullfile(Pros.folderpath_experiment, filename_figure);
			saveas(figure010,filepath_figure);
			
			
		end % end for index_figure
		
		
	case '3'
		%% 列举数据里对应的图像（论文用_3）
		
	case '4'
		%% 列举数据里对应的图像（论文用_4）
		%% TODO
		
	case '5'
		%% 列举数据里对应的图像（论文用_5）
		%% TODO
		filename_figure = ['论文展示图' num2str(index_fig) '.jpg'];
		filepath_figure = fullfile(Pros.folderpath_experiment, filename_figure);
		saveas(figure010,filepath_figure);
		
		
	otherwise
		error('error at choose mode !')
		
end









%%
diary off;
toc;
text=['程序运行完毕。'];
disp(text)
sp.Speak(text);
