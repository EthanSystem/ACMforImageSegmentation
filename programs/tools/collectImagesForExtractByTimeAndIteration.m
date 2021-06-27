%% ���
% collectImagesForExtractByHuman.m ʵ����ȡ�ֱ����� Iteration �� Time �����������ĸ���������ͼ���Լ���ֵͼ��ָ���ļ����Ա����˹�ɸѡ
% ��ȡָ�����ļ����ļ��е�ģʽ���������֣�
% ģʽ1 ��ʾ�ڴ��н�ǿ������ָ��ĵ�һ��ɸѡ�£���ȡ��Ӧͼ��
% ģʽ2 ��ʾ�ڴ��н���������ָ��ĵ�һ��ɸѡ�£���ȡ��Ӧͼ��
% ģʽ3 ��ʾ��ɸѡ������£���ȡ��Ӧͼ��
% ע���������ʱ����ʾҪ������ʵ���飡


%% Ԥ����
clear all;
close all;
clc;
diary off;
sp=actxserver('SAPI.SpVoice');


%% �û������ʼ���� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Args.mode = '1' ; % ��ȡָ�����ļ����ļ��е�ģʽ������������
Args.folderpath_EachImageBaseFolder = '.\data\resources\CV�ڲ�����ͼƬ�ϱ��ֲ���'; % ������ȡ�ļ��Ľṹ�� EachImage �Ļ���·��
Args.folderpath_ResultsBaseFolder = '.\data\evaluation\CV�ڲ�����ͼƬ�ϱ��ֲ���'; % ������ȡ�ļ��Ľṹ�� Results �Ļ���·����
Args.folderpath_experiment = '.\data\evaluation\circleACMGMM 5-28������\��Ҫ���м����н����'; % ������ȡ�ļ��Ľṹ�� Results �Ļ���·����
Args.folderpath_outputBase = '.\data\extract\CV�ڲ�����ͼƬ�ϱ��ֲ��� ɸ'; % ��ȡ�ļ���Ŀ���ļ���
Args.outputMode = 'datatime' ;	 % ָ��������ʵ����ļ��е��ļ�������ʾ���͡���ѡ 'datatime' 'index'��'datatime' ��ʾʵ���ļ�������������ʱ�䣻'index'��ʾʵ���ļ��������Ǳ�š�Ĭ�� 'datatime'���Ƽ���Ĭ��ֵ��
Args.num_scribble = 1; % ���д������ͼ��ı������������Ŀǰ��ʱ�����ǲ�ͬ��ǶԷָ�Ч����Ӱ�죬��������һ��ͼ��һ�ֱ�ǣ����Ŀǰ�ֶ�����Ϊ1��
Args.isVisual = 'no' ;  % ���ƹ��̲����ӻ���������������в鿴����� 'yes'��ʾ���ƹ����п��ӻ� ��'no'��ʾ���ƹ����в����ӻ���Ĭ��'no'
Args.numUselessFiles = 0; % Ҫ�ų���ͼ����������ʱ��洢ͼƬ���ļ��г�����ͼ���ļ������п�����ϵͳ�ļ��ᱻ���������Ҫ�ֶ��ų���
Args.ratioOfGood = 0.7 ; % ����õ�ͼ�����ռ��ָ���ֵ�ı�����ֵ��ֵ��[0,1]��Ĭ�� 0.85
Args.ratioOfBad = 0.5 ; % ������ͼ�����ռ��ָ���ֵ�ı�����ֵ��ֵ��[0,1]��Ĭ�� 0.65
Args.ratioOfBetter = 0.3 ; % ���ַ����Ƚ�ʱ������AҪ�ȷ���B��ָ���ֵ�ı���Ҫ���ڵ��ڸ�ֵ������Ϊ���Ժá�ֵ��[0,1]��Ĭ�� 0.3
Args.ratioOfBetterAtBothGood = 0.001 ; % ���ַ����Ƚ�ʱ�����ַ������õ�����£�����AҪ�ȷ���B��ָ���ֵ�ı���Ҫ���ڵ��ڸ�ֵ������Ϊ���Ժá�ֵ��[0,1]��Ĭ��0.1
Args.ratioOfRegion = 1.0; % ʵ����Ͷ�����Ƚ�ʱ��ʵ����Ч���ȶ�����Ч�����õ�ͼ������ ռ ʵ����Ч���ȶ�����Ч���õ�ͼ������ �ı�����
Args.ratioOfRand = 0.1; % ����ʵ����Ͷ�����Ƚ�ʱ��ʵ����Ч���õ�ͼ������ռ��ͼ�������ı����������Χ��
Args.ratioImagesShow = 1.0 ; % Ҫ��ȡ��ͼ���������Ʊ�����ֵ��[0,1]��Ĭ��0.1��

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% properties
Pros = Args;

%% �����ļ��е���Դresources �ṹ��EachImage������results�ļ�����ָ������ָ����ļ�·�������ƵĽṹ�� Results
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

%% ����ʵ���飺
Args.experiment = input('ȷ���ļ�������ļ������Ƿ���ȷ����ȷ�Ļ�������ָ��ʵ���飬������������ Ctrl+c ��ֹ����')
Pros = Args;

%% �����ļ���
switch Args.outputMode
	case 'datatime'
		% ����һ������Ϊ������ʱ����������ļ�������ÿһ�ε�ʵ������
		Pros.foldername_experiment=[datestr(now,'dd-HHMMSS') '_evaluationAnalyse'];
	case 'index'
		Pros.foldername_experiment = ['��' num2str(index_experiment) '��ʵ��'];
end
Pros.folderpath_experiment=fullfile(Pros.folderpath_outputBase, Pros.foldername_experiment);
mkdir(Pros.folderpath_experiment);

% properties
Pros.num_scribble =1; % ��ǵ�������Ŀǰ�����ǲ�ͬ�ı�Ƕ�ʵ������Ӱ�죬�������Ϊ1
% Ҫ�����ͼ����������ʱ��洢ͼƬ���ļ��г�����ͼ���ļ������п�����ϵͳ�ļ��ᱻ���������Ҫ�ֶ��ų�
Pros.num_image = EachImage.num_groundTruthBwImage;
Pros.num_experiments = Results.num_experiments;

%% ��¼��־
% ����diary����ļ���
Pros.filename_diary = 'diary evaluation analyse.txt';
Pros.filepath_diary = fullfile(Pros.folderpath_experiment, Pros.filename_diary);
diary(Pros.filepath_diary);
diary on;
Args


%% ��ʱ
tic;

switch Pros.mode
	case '1'
		
		%% ��ӡ
		disp(['����õ�ͼ�����ռ��ָ���ֵ�ı�����ֵ��' num2str(Pros.ratioOfGood)])
		disp(['������ͼ�����ռ��ָ���ֵ�ı�����ֵ��' num2str(Pros.ratioOfBad)])
		disp(['���ַ����Ƚ�ʱ������AҪ�ȷ���B��ָ���ֵ�ı���Ҫ���ڵ��ڸ�ֵ������Ϊ���Ժá���ֵ����Ϊ��' num2str(Pros.ratioOfBetter)])
		disp(['���ַ����Ƚ�ʱ�����ַ������õ�����£�����AҪ�ȷ���B��ָ���ֵ�ı���Ҫ���ڵ��ڸ�ֵ������Ϊ���Ժá���ֵ����Ϊ��' num2str(Pros.ratioOfBetterAtBothGood)])
		disp(['ʵ����Ͷ�����Ƚ�ʱ��ʵ����Ч���õ�ͼ������ռ��ͼ�������ı�������ֵ����Ϊ��' num2str(Pros.ratioOfRegion)])
		disp(['����ʵ����Ͷ�����Ƚ�ʱ��ʵ����Ч���õ�ͼ������ռ��ͼ�������ı����������Χ����ֵ����Ϊ��' num2str(Pros.ratioOfRand)])
		
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
		
		%% �� Iteration ָ���£�ʵ����Ч���ã�������Ч���ϲ��ͼ��
		% ��ȡ����������ͼ������
		images1better_iteration(:,1)=find(iterationIndicator(:,Pros.experiment)<=mean(iterationIndicator(:,Pros.experiment),1));
		array_experiments = 1:Results.num_experiments;
		array_experiments(Pros.experiment)=[];
		for i=array_experiments
			temp1(:,1)=find( (iterationIndicator(:,i)>=mean(iterationIndicator(:,i))) & (iterationIndicator(:,Pros.experiment)<=iterationIndicator(:,i))  );
			temp2(:,1) = intersect(images1better_iteration, temp1);
			images1better_iteration=temp2;
			clear temp1 temp2;
		end
		% ���ɷ���������ͼ�񼯺Ϲ��ɵ��µ�Iteration����
		for i=1:Pros.num_experiments
			images1better_iteration(:,i+1) = iterationIndicator(images1better_iteration(:,1),i);
		end
		% ��ȡ����������ͼ������
		num_images1better_iteration=size(images1better_iteration,1);
		% ��ȡ���� Iteration ���������ͼ��
		randInterger1 = randperm(size(images1better_iteration,1),ceil(Pros.ratioImagesShow*num_images1better_iteration));
		imagesNeed=images1better_iteration(randInterger1,1);
		num_imagesNeeded = size(imagesNeed,1);
		
		% collect �ռ���Ҫ��ͼ��ָ�����ļ���
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
		
		%% �� Time ָ���£�ʵ����Ч���ã�������Ч���ϲ��ͼ��
		% ��ȡ����������ͼ������
		images1better_time(:,1)=find(timeIndicator(:,Pros.experiment)<=mean(timeIndicator(:,Pros.experiment)));
		array_experiments = 1:Results.num_experiments;
		array_experiments(Pros.experiment)=[];
		for i=array_experiments
			temp1(:,1)=find( (timeIndicator(:,i)>=mean(timeIndicator(:,i))) & (timeIndicator(:,Pros.experiment)<=timeIndicator(:,i))  );
			temp2(:,1) = intersect(images1better_time, temp1);
			images1better_time=temp2;
			clear temp1 temp2;
		end
		% ���ɷ���������ͼ�񼯺Ϲ��ɵ��µ�Iteration����
		for i=1:Pros.num_experiments
			images1better_time(:,i+1) = timeIndicator(images1better_time(:,1),i);
		end
		% ��ȡ����������ͼ������
		num_images1better_time=size(images1better_time,1);
		% ��ȡ���� Time ���������ͼ��
		randInterger1 = randperm(size(images1better_time,1),ceil(Pros.ratioImagesShow*num_images1better_time));
		imagesNeed=images1better_time(randInterger1,1);
		num_imagesNeeded = size(imagesNeed,1);
		
		% collect �ռ���Ҫ��ͼ��ָ�����ļ���
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
		%% ��ȡ���ͼ��
		% ��ȡ���ͼ���������ļ����Է����û�ɸѡ
		
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
			
			
% 			% �����Ҫ�м����Ļ�������������δ��롾
% 			for index_experiment = 1:Pros.num_experiments
% 							filename_newImg = [EachImage.originalImage(index_image).name(1:end-4) '_' Results_final.experiments(index_experiment).name '.bmp'];
% 				copyfile(Results_final.experiments(index_experiment).bwImages(index_image).path, fullfile(folderpath_images, filename_newImg));
% 			end
% 			% ��
		end
		
		
	otherwise
		error('error at choose mode');
end


%%
diary off;
toc;
text=['����������ϡ�'];
disp(text)
sp.Speak(text);
