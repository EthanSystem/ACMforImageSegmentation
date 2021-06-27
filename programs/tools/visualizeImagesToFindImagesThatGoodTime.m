%% ���
% visualizeImagesToFindImagesThatGoodTime.m ���ӻ���Ѱ�Һ��ʵ�ͼ���������ǵĵ���������ġ�
% mode = '1' ��ʾÿ�ַ����ĸ���ͼ��Ķ�ֵͼ����չʾ��
% mode = '2' ��ʾÿһ�б�ʾһ��ͼ��ÿ��ͼ����ԭͼ����ֵͼ���������Ķ�ֵͼ��
% mode = '3' �� mode = '2' ��ת�ã�
% mode = '4' �� ��2�� ���ƣ������ǽ����Ų���
% mode = '5' �� ��3�� ���ƣ������ǽ����Ų���

%% Ԥ����
clear all;
close all;
clc;
diary off;
sp=actxserver('SAPI.SpVoice');


%% �û������ʼ���� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Args.mode = '1' ; % mode = '1' ��ʾÿ�ַ����ĸ���ͼ��Ķ�ֵͼ����չʾ��mode = '2' ��ʾÿһ�б�ʾһ��ͼ��ÿ��ͼ����ԭͼ����ֵͼ���������Ķ�ֵͼ
Args.labelStr = 'JD';
Args.folderpath_EachImageBaseFolder = '.\data\resources\�Ƚ�ͬһ����'; % ���ڼ����ļ��Ľṹ�� EachImage �Ļ���·��
Args.folderpath_ResultsBaseFolder = '.\data\segmentations\�Ƚ�ͬһ����'; % ���ڼ����ļ��Ľṹ�� Results �Ļ���·����
Args.folderpath_outputBase = '.\data\exportForPaper\�Ƚ�ͬһ����'; % ָ������������ļ��еĻ���·����
Args.outputMode = 'datatime';	 % ָ��������ʵ����ļ��е��ļ�������ʾ���͡���ѡ 'datatime' 'index'��'datatime' ��ʾʵ���ļ�������������ʱ�䣻'index'��ʾʵ���ļ��������Ǳ�š�Ĭ�� 'datatime'���Ƽ���Ĭ��ֵ��Args.num_scribble = 1; % ���д������ͼ��ı������������Ŀǰ��ʱ�����ǲ�ͬ��ǶԷָ�Ч����Ӱ�죬��������һ��ͼ��һ�ֱ�ǣ����Ŀǰ�ֶ�����Ϊ1��
Args.isVisual = 'off' ;  % ���ƹ��̲����ӻ���������������в鿴����� 'on'��ʾ���ƹ����п��ӻ� ��'off'��ʾ���ƹ����в����ӻ���Ĭ��'off'
Args.numUselessFiles = 0; % Ҫ�����ͼ����������ʱ��洢ͼƬ���ļ��г�����ͼ���ļ������п�����ϵͳ�ļ��ᱻ���������Ҫ�ֶ��ų���
Args.numImagesShow = 10; % ÿ��figҪչʾ��ͼ�����������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% properties
Pros = Args;

%% �����ļ��е���Դresources �ṹ��EachImage������results�ļ�����ָ������ָ����ļ�·�������ƵĽṹ�� Results
EachImage = createEachImageStructure(Pros.folderpath_EachImageBaseFolder, Pros.numUselessFiles);
Results = createResultsStructure(Pros.folderpath_ResultsBaseFolder, Pros.numUselessFiles);

% Pros.indexOfScribbledImageFolder = findIndexOfFolderName(EachImage, 'scribbled images');
% Pros.indexOfOriginalImageFolder = findIndexOfFolderName(EachImage, 'original images');
% Pros.indexOfBwDataFolder = findIndexOfFolderName(EachImage, 'bw data');
% Pros.indexOfBwImagesFolder = findIndexOfFolderName(EachImage, 'bw images');
% Pros.indexOfGTFolder = findIndexOfFolderName(EachImage, 'ground truth images');
% Pros.indexOfEvaluationsFolder = findIndexOfFolderName(EachImage, 'evaluations');
% Pros.indexOfFiguresFolder = findIndexOfFolderName(EachImage, 'figures');

input('ȷ���ļ�������ļ������Ƿ���ȷ����ȷ����������������� Ctrl+c ��ֹ����')

%% �����������۵Ŀ��ӻ����ļ��У������п��ӻ�
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
% Ҫ�����ԭʼͼ����������ʱ��洢ͼƬ���ļ��г�����ͼ���ļ������п�����ϵͳ�ļ��ᱻ���������Ҫ�ֶ��ų�
Pros.num_originalImage = EachImage.num_originalImage;
Pros.num_experiments = Results.num_experiments;


% 
% %% ��¼��־
% % ����diary����ļ���
% Pros.filename_diary = 'diary evaluation analyse.txt';
% Pros.filepath_diary = fullfile(Pros.folderpath_experiment, Pros.filename_diary);
% diary(Pros.filepath_diary);
% diary on;


%% ��ʱ
tic;

%%


switch Pros.mode
	case '1'
		%% �о��������Ӧ��ͼ��������_1��
		% 		figure010 = figure('Name',[num2str(Pros.numImagesShow) ' ��ɸѡ��ͼ���� ' labelStr ' ָ���µ�����ͼ'],'Position',[20 20 2000 600],'Visible',controlVis);
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
		
		row=min_iter+3; % ���� 3 ��ʾԭͼ����ֵͼ����ʼ����ͼ
		index_bwData = ones(1,col);
		
		for index_image = 1:EachImage.num_originalImage
			% 			figure010 = figure('Name',[EachImage.originalImage(index_image).path ' �ڲ�ͬ�����Ĵ�����������Ա�ͼ'],'Position',[20 20 400*col 400*row],'Visible',Pros.isVisual);
			figure010 = figure('Name',[EachImage.originalImage(index_image).name ' �ڲ�ͬ�����Ĵ�����������Ա�ͼ'],'Position',[20 20 400*col 400*num_iter(index_image,index_method)],'Visible',Pros.isVisual);
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
			filename_figure = [EachImage.originalImage(index_image).name ' �ڲ�ͬ�����Ĵ�����������Ա�ͼ.jpg'];
			filepath_figure = fullfile(Pros.folderpath_experiment, filename_figure);
			saveas(figure010,filepath_figure);
			
			
		end % end for index_figure
		
		
	case '2'
		%% �о��������Ӧ��ͼ��������_2��
		col=Results.num_experiments;
		for index_image = 1:EachImage.num_originalImage
			for index_method = 1:col
				load(Results.experiments(index_method).evaluationData.path);
				num_iter(index_image,index_method) = elipsedEachTime.iteration(index_image); % ���� 2 ��ʾԭͼ����ֵͼ
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
			% 			figure010 = figure('Name',[EachImage.originalImage(index_image).path ' �ڲ�ͬ�����Ĵ�����������Ա�ͼ'],'Position',[20 20 400*col 400*row],'Visible',Pros.isVisual);
			figure010 = figure('Name',[EachImage.originalImage(index_image).name ' �ڲ�ͬ�����Ĵ�����������Ա�ͼ'],'Position',[20 20 400*col 400*num_iter(index_image,index_method)],'Visible',Pros.isVisual);
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
			filename_figure = [EachImage.originalImage(index_image).name ' �ڲ�ͬ�����Ĵ�����������Ա�ͼ.jpg'];
			filepath_figure = fullfile(Pros.folderpath_experiment, filename_figure);
			saveas(figure010,filepath_figure);
			
			
		end % end for index_figure
		
		
	case '3'
		%% �о��������Ӧ��ͼ��������_3��
		
	case '4'
		%% �о��������Ӧ��ͼ��������_4��
		%% TODO
		
	case '5'
		%% �о��������Ӧ��ͼ��������_5��
		%% TODO
		filename_figure = ['����չʾͼ' num2str(index_fig) '.jpg'];
		filepath_figure = fullfile(Pros.folderpath_experiment, filename_figure);
		saveas(figure010,filepath_figure);
		
		
	otherwise
		error('error at choose mode !')
		
end









%%
diary off;
toc;
text=['����������ϡ�'];
disp(text)
sp.Speak(text);
