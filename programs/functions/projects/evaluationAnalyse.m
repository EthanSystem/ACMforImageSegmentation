%% ���
% evaluationAnalyse.m ʵ�ֶ�����ָ��ĸ��ַ����Ϳ��ӻ�

%% Ԥ����
clear all;
close all;
clc;
diary off;
sp=actxserver('SAPI.SpVoice');


%% �û������ʼ���� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Args.evolutionAnalyseMode = '2' ;  % ����ģʽ��'1' ��ʾ�����㷨�ȽϷ�����'2' ��ʾ���з���һ�������
Args.ImageSetMode = '1' ; % �����������ݼ����������͡�'1' ��ʾ��Results��׼�ļ��ŷŷ�ʽ��ȡ������������ ��2�� ��ʾ��ԭͼ����ֵͼ����������ֵͼ���ڵ�Ψһһ���ļ���������ȡ������������

Args.folderpath_reourcesDatasets = '.\data\expr2_analysis_semiACMGMM_��ҵ�����������ͼƬ\original resources';  % ������Դ�ļ���ԭͼ����ֵͼ�����ͼ���Ļ���·��
% ��ʵ folderpath_initBaseFolder �ڼ���ָ���ʱ����Ҫ���������һ���Ϳ����ˡ�
Args.folderpath_initBaseFolder = '.\data\expr2_analysis_semiACMGMM_��ҵ�����������ͼƬ\init resources';  % ������ʼ���ļ������ֳ�ʼ���������ɵ����ʼ������ֵͼ����������ʱ������ȣ��Ļ���·��
Args.folderpath_ResultsBaseFolder = '.\data\expr2_analysis_semiACMGMM_��ҵ�����������ͼƬ\evaluation'; % ���ڼ����ļ��Ľṹ�� Results �Ļ���·����
Args.folderpath_outputBase = '.\data\expr2_analysis_semiACMGMM_��ҵ�����������ͼƬ\analysis'; % ����������ӻ�����Ļ���·��

% Args.folderpath_reourcesDatasets = '.\data\expr1_analysis_ACMGMM_ԭ�����ĵ�ͼ\original resources';  % ������Դ�ļ���ԭͼ����ֵͼ�����ͼ���Ļ���·��
% % ��ʵ folderpath_initBaseFolder �ڼ���ָ���ʱ����Ҫ���������һ���Ϳ����ˡ�
% Args.folderpath_initBaseFolder = '.\data\expr1_analysis_ACMGMM_ԭ�����ĵ�ͼ\init resources';  % ������ʼ���ļ������ֳ�ʼ���������ɵ����ʼ������ֵͼ����������ʱ������ȣ��Ļ���·��
% Args.folderpath_ResultsBaseFolder = '.\data\expr1_analysis_ACMGMM_ԭ�����ĵ�ͼ\evaluation'; % ���ڼ����ļ��Ľṹ�� Results �Ļ���·����
% Args.folderpath_outputBase = '.\data\expr1_analysis_ACMGMM_ԭ�����ĵ�ͼ\analysis'; % ����������ӻ�����Ļ���·��

Args.outputMode = 'datatime';	 % ָ��������ʵ����ļ��е��ļ�������ʾ���͡���ѡ 'datatime' 'index'��'datatime' ��ʾʵ���ļ�������������ʱ�䣻'index'��ʾʵ���ļ��������Ǳ�š�Ĭ�� 'datatime'���Ƽ���Ĭ��ֵ��
Args.num_scribble = 1; % ���д������ͼ��ı������������Ŀǰ��ʱ�����ǲ�ͬ��ǶԷָ�Ч����Ӱ�죬��������һ��ͼ��һ�ֱ�ǣ����Ŀǰ�ֶ�����Ϊ1��
Args.isVisual = 'no' ;  % ���ƹ��̲����ӻ���������������в鿴����� 'yes'��ʾ���ƹ����п��ӻ� ��'no'��ʾ���ƹ����в����ӻ���Ĭ��'no'
Args.numUselessFiles = 0; % Ҫ�ų���ͼ����������ʱ��洢ͼƬ���ļ��г�����ͼ���ļ������п�����ϵͳ�ļ��ᱻ���������Ҫ�ֶ��ų���
Args.ratioOfGood = 0.75 ; % ����õ�ͼ�����ռ��ָ���ֵ�ı�����ֵ��ֵ��[0,1]��Ĭ�� 0.85
Args.ratioOfBad = 0.60 ; % ������ͼ�����ռ��ָ���ֵ�ı�����ֵ��ֵ��[0,1]��Ĭ�� 0.65
Args.ratioOfBetter = 0.01 ; % ���ַ����Ƚ�ʱ������AҪ�ȷ���B��ָ���ֵ�ı���Ҫ���ڵ��ڸ�ֵ������Ϊ���Ժá�ֵ��[0,1]��Ĭ�� 0.3
Args.ratioOfBetterAtBothGood = 0.01 ; % ���ַ����Ƚ�ʱ�����ַ������õ�����£�����AҪ�ȷ���B��ָ���ֵ�ı���Ҫ���ڵ��ڸ�ֵ������Ϊ���Ժá�ֵ��[0,1]��Ĭ��0.1
Args.numImagesShow = 20 ;
Args.lineWidth = 1;
Args.markerSize = 3;
Args.figSize = [1000 300];

% ���� evolutionAnalyseMode = '1'
% ʵ������1����������2��
Args.experiment01 = 1 ;
Args.experiment02 = 2 ;

% ���� evolutionAnalyseMode = '2'
% ���ո�����Restuls���������������ĸ������Ȼ��ƣ��Ǹ���������ơ�
% ���ƹ�������������������ӵ�����£�����Ƶ��������׸����Ȼ��Ƶ���������ˣ�һ�㿼������Ҫͻ����ʾ��ʵ�������ơ�
Args.experimentSequence = [2 1]; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% properties
Pros = Args;


%% �����ļ��е���Դresources �ṹ��EachImage������results�ļ�����ָ������ָ����ļ�·�������ƵĽṹ�� Results
EachImage_ref = createEachImageStructure(Pros.folderpath_reourcesDatasets, Pros.folderpath_initBaseFolder, Pros.numUselessFiles);
Results_ref = createResultsStructure(Pros.folderpath_ResultsBaseFolder, Pros.numUselessFiles);
EachImage = createEachImageStructure(Pros.folderpath_reourcesDatasets, Pros.folderpath_initBaseFolder, Pros.numUselessFiles);
Results = createResultsStructure(Pros.folderpath_ResultsBaseFolder, Pros.numUselessFiles);


input('ȷ���ļ�������ļ������Ƿ���ȷ����ȷ����������������� Ctrl+c ��ֹ����')






%% �����������۵Ŀ��ӻ����ļ��У������п��ӻ�
switch Args.outputMode
	case 'datatime'
		% ����һ������Ϊ������ʱ����������ļ�������ÿһ�ε�ʵ������
		Pros.foldername_experiment=['evaluation' '_' datestr(now,'ddHHMMSS')];
	case 'index'
		Pros.foldername_experiment = ['��' num2str(index_experiment) '��ʵ��'];
end
Pros.folderpath_experiment=fullfile(Pros.folderpath_outputBase, Pros.foldername_experiment);
% Pros.folderpath_experiment=Pros.folderpath_outputBase;
mkdir(Pros.folderpath_experiment);

% properties
Pros.num_scribble =1; % ��ǵ�������Ŀǰ�����ǲ�ͬ�ı�Ƕ�ʵ������Ӱ�죬�������Ϊ1
% Ҫ�����ͼ����������ʱ��洢ͼƬ���ļ��г�����ͼ���ļ������п�����ϵͳ�ļ��ᱻ���������Ҫ�ֶ��ų�
Pros.num_image = EachImage_ref.num_groundTruthBwImage;

%% ��¼��־
% ����diary����ļ���
Pros.filename_diary = 'diary evaluation analyse.txt';
Pros.filepath_diary = fullfile(Pros.folderpath_experiment, Pros.filename_diary);
diary(Pros.filepath_diary);
diary on;

%% ��ʱ
tic;

%% ��ӡ
disp(['����õ�ͼ�����ռ��ָ���ֵ�ı�����ֵ = ' num2str(Pros.ratioOfGood)])
disp(['������ͼ�����ռ��ָ���ֵ�ı�����ֵ = ' num2str(Pros.ratioOfBad)])
disp(['���ַ����Ƚ�ʱ������AҪ�ȷ���B��ָ���ֵ�ı���Ҫ���ڵ��ڸ�ֵ������Ϊ���Ժá���ֵ����Ϊ = ' num2str(Pros.ratioOfBetter)])
disp(['���ַ����Ƚ�ʱ�����ַ������õ�����£�����AҪ�ȷ���B��ָ���ֵ�ı���Ҫ���ڵ��ڸ�ֵ������Ϊ���Ժá���ֵ����Ϊ = ' num2str(Pros.ratioOfBetterAtBothGood)])

%%
switch Pros.evolutionAnalyseMode
	case '1'
		%% ͳ�����ַָ������ͼ��Ĺ���ͼ�����������ԣ��ҳ�һ����õ�ͼ�񼯺ϡ�
		switch Pros.ImageSetMode
			case '1'
				evaluation_statistic('Jaccard', Pros, EachImage_ref, Results_ref, Pros.experiment01, Pros.experiment02);
				evaluation_statistic('ModifiedHausdorff', Pros, EachImage_ref, Results_ref, Pros.experiment01, Pros.experiment02);
				evaluation_statistic('F1', Pros, EachImage_ref, Results_ref, Pros.experiment01, Pros.experiment02);
				
				%% �Ա����ַ����õ�ɢ��ֲ�ͼ
				visualizeCompareTwoMethod('Jaccard', Pros, EachImage_ref, Results_ref, Pros.experiment01, Pros.experiment02, Pros.isVisual);
				visualizeCompareTwoMethod('ModifiedHausdorff', Pros, EachImage_ref, Results_ref, Pros.experiment01, Pros.experiment02, Pros.isVisual);
				visualizeCompareTwoMethod('F1', Pros, EachImage_ref, Results_ref, Pros.experiment01, Pros.experiment02, Pros.isVisual);
				
				
				%% �Ƚ�macro-F1��ֵ
				load(Results_ref.experiments(Pros.experiment01).evaluationData(3).path);
				macroF1_1=macroF1;
				load(Results_ref.experiments(Pros.experiment02).evaluationData(3).path);
				macroF1_2=macroF1;
				disp(['���� ' Results_ref.experiments(Pros.experiment01).name ' �� macro-F1 ָ���ֵ�ǣ�' num2str(macroF1_1)])
				disp(['���� ' Results_ref.experiments(Pros.experiment02).name ' �� macro-F1 ָ���ֵ�ǣ�' num2str(macroF1_2)])
			case '2'
				
			otherwise
				error('error at choose mode !')
		end
	case '2'
		%% ���ӻ�ָ��
		switch Pros.ImageSetMode
			case '1'
				visualizeIndicator('Jaccard', Pros, Results_ref, Pros.num_image, Pros.num_scribble, Results_ref.num_experiments, Pros.isVisual, Pros.experimentSequence);
				visualizeIndicator('ModifiedHausdorff', Pros, Results_ref ,Pros.num_image, Pros.num_scribble, Results_ref.num_experiments, Pros.isVisual, Pros.experimentSequence);
				visualizeIndicator('F1', Pros, Results_ref, Pros.num_image, Pros.num_scribble, Results_ref.num_experiments, Pros.isVisual, Pros.experimentSequence);
				visualizeIndicator('macro-F1', Pros, Results_ref, Pros.num_image, Pros.num_scribble, Results_ref.num_experiments, Pros.isVisual, Pros.experimentSequence);
				visualizeIndicator('time', Pros, Results_ref, Pros.num_image, Pros.num_scribble, Results_ref.num_experiments, Pros.isVisual, Pros.experimentSequence);
				visualizeIndicator('iteration', Pros, Results_ref, Pros.num_image, Pros.num_scribble, Results_ref.num_experiments, Pros.isVisual, Pros.experimentSequence);
				
				
				%% ���������õ�ͼ������ͼ
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
		
		%% �������� ����������ƽ��ʱ���ƽ����������
		
		
		
		
	otherwise
		disp(['error at choose mode !']);
end
%%
diary off;
toc;
text=['����������ϡ�'];
disp(text)
sp.Speak(text);





