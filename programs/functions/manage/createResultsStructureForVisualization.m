function [ Results ] = createResultsStructureForVisualization( baseFolder, numUselessFiles )
%createResultsStructure �˴���ʾ�йش˺�����ժҪ
%   input:
% numUselessFiles��Ҫ��ȥ�����õ��ļ��������Windowsϵͳ��ͼ���ļ�������ļ���Thumbs.db��
% output:
% Results������һ���ṹ��

%% ����results�ļ�����ָ������ָ����ļ�·�������ƵĽṹ�� Results
Results.folderpath_outputBase = [ baseFolder ];
Results.experiments=dir(Results.folderpath_outputBase);	% ÿ��ʵ����ļ����б�
Results.experiments(1:2,:)=[]; 
% % ��ȡָ��Ҫ�����ʵ���ļ��е�����ֵ
% index_experiment = findIndexOfExprimentFolder(Results.experiments, Pros.foldername);

Results.num_experiments=numel(Results.experiments);
if Results.num_experiments~=0
	for index_experiment=1:Results.num_experiments
		%% ָ��ʵ����ļ���
		Results.experiments(index_experiment).path=fullfile(Results.folderpath_outputBase, Results.experiments(index_experiment).name);
% 		foldersInEachExperiments=dir(Results.experiments(index_experiment).path);
		
% 		%% ����diary����ļ���
% 		Results.experiments(index_experiment).diary.name = 'diary output';
% 		Results.experiments(index_experiment).diary.folderpath = fullfile(Results.experiments(index_experiment).path, Results.experiments(index_experiment).diary.name);
% 		mkdir(Results.experiments(index_experiment).diary.folderpath);
% 		if ~exist(Results.experiments(index_experiment).diary.folderpath,'dir')
% 			mkdir(Results.experiments(index_experiment).diary.folderpath);
% 		end
		
		%% ���շָ��ֵͼ��ͼ�ļ���·��
		Results.experiments(index_experiment).folderpath_bwImage = [Results.experiments(index_experiment).path];
		% ÿ�����շָ��ֵͼ��ͼ���ƺ�·��
		Results.experiments(index_experiment).bwImages= dir([Results.experiments(index_experiment).folderpath_bwImage '\*.bmp']);
		Results.experiments(index_experiment).num_bwImage = numel(Results.experiments(index_experiment).bwImages)-numUselessFiles;
		disp(['ʵ���ļ��� ' Results.experiments(index_experiment).name ' �� ' num2str(Results.experiments(index_experiment).num_bwImage) ' ���ָ��ֵͼ�ļ�'])
		if Results.experiments(index_experiment).num_bwImage ~=0
			for index_bwImage= 1:Results.experiments(index_experiment).num_bwImage
				Results.experiments(index_experiment).bwImages(index_bwImage).path = fullfile(Results.experiments(index_experiment).folderpath_bwImage, Results.experiments(index_experiment).bwImages(index_bwImage).name);
			end
		else
			disp(['�ļ��� ' Results.experiments(index_experiment).folderpath_bwImage ' û�зָ��ֵͼ�ļ�...']);
		end
		
% 		%% ���շָ��ֵ�����ļ���·��
% 		Results.experiments(index_experiment).folderpath_bwData = fullfile(Results.experiments(index_experiment).path, 'bw data');
% 		if ~exist(Results.experiments(index_experiment).folderpath_bwData,'dir')
% 			mkdir(Results.experiments(index_experiment).folderpath_bwData);
% 		end
% 		% ÿ�����շָ��ֵ�������ƺ�·��
% 		Results.experiments(index_experiment).bwData= dir([Results.experiments(index_experiment).folderpath_bwData '\*.mat']);
% 		Results.experiments(index_experiment).num_bwData = numel(Results.experiments(index_experiment).bwData)-numUselessFiles;
% 		disp(['ʵ���ļ��� ' Results.experiments(index_experiment).name ' ���ļ��� bw data �� ' num2str(Results.experiments(index_experiment).num_bwData) ' ���ļ�'])
% 		if Results.experiments(index_experiment).num_bwData ~=0
% 			for index_bwData= 1:Results.experiments(index_experiment).num_bwData
% 				Results.experiments(index_experiment).bwData(index_bwData).path = fullfile(Results.experiments(index_experiment).folderpath_bwData, Results.experiments(index_experiment).bwData(index_bwData).name);
% 			end
% 		else
% 			disp(['�ļ��� ' Results.experiments(index_experiment).folderpath_bwImage ' û�зָ��ֵ�����ļ�...']);
% 		end
		
% 		%% ����Ƕ�뺯���ļ���·��
% 		Results.experiments(index_experiment).folderpath_phiData = fullfile(Results.experiments(index_experiment).path, 'phi data');
% 		if ~exist(Results.experiments(index_experiment).folderpath_phiData,'dir')
% 			mkdir(Results.experiments(index_experiment).folderpath_phiData);
% 		end
% 		% ÿ������Ƕ�뺯�����ƺ�·��
% 		Results.experiments(index_experiment).phiData= dir([Results.experiments(index_experiment).folderpath_phiData '\*.mat']);
% 		Results.experiments(index_experiment).num_phiData = numel(Results.experiments(index_experiment).phiData);
% 		disp(['ʵ���ļ��� ' Results.experiments(index_experiment).name ' ���ļ��� phi data �� ' num2str(Results.experiments(index_experiment).num_phiData) ' ���ļ�'])
% 		if Results.experiments(index_experiment).num_phiData ~=0
% 			for index_phiData= 1:Results.experiments(index_experiment).num_phiData
% 				Results.experiments(index_experiment).bwImage(index_phiData).path = fullfile(Results.experiments(index_experiment).folderpath_phiData, Results.experiments(index_experiment).phiData(index_phiData).name);
% 			end
% 		else
% 			disp(['�ļ��� ' Results.experiments(index_experiment).folderpath_bwImage ' û��Ƕ�뺯���ļ�...']);
% 		end
		
% 		%% ���ͼ��ı�����������ļ���·��
% 		Results.experiments(index_experiment).folderpath_seeds = fullfile(Results.experiments(index_experiment).path, 'seeds data');
% 		if ~exist(Results.experiments(index_experiment).folderpath_seeds,'dir')
% 			mkdir(Results.experiments(index_experiment).folderpath_seeds);
% 		end
% 		% ÿ�����ͼ����������ݵ����ƺ�·��
% 		Results.experiments(index_experiment).seeds = dir([Results.experiments(index_experiment).folderpath_seeds '\*.mat']);
% 		Results.experiments(index_experiment).num_seeds = numel(Results.experiments(index_experiment).seeds);
% 		disp(['ʵ���ļ��� ' Results.experiments(index_experiment).name ' ���ļ��� seeds data �� ' num2str(Results.experiments(index_experiment).num_seeds) ' ���ļ�'])
% 		if Results.experiments(index_experiment).num_seeds ~=0
% 			for index_seeds = 1:Results.experiments(index_experiment).num_seeds
% 				Results.experiments(index_experiment).seeds(index_seeds).path = fullfile(Results.experiments(index_experiment).folderpath_seeds, Results.experiments(index_experiment).seeds(index_seeds).name);
% 			end
% 		else
% 			disp(['�ļ��� ' Results.experiments(index_experiment).folderpath_seeds ' û�б�������ļ�...']);
% 		end
		
% 		%% �����ͼ�ļ���·��
% 		Results.experiments(index_experiment).folderpath_screenShot = fullfile(Results.experiments(index_experiment).path, 'screen shot');
% 		if ~exist(Results.experiments(index_experiment).folderpath_screenShot,'dir')
% 			mkdir(Results.experiments(index_experiment).folderpath_screenShot);
% 		end
% 		% ÿ�����ͼ�Ľ�ͼ���ƺ�·��
% 		Results.experiments(index_experiment).screenShot = dir([Results.experiments(index_experiment).folderpath_screenShot '\*.jpg']);
% 		Results.experiments(index_experiment).num_screenShot = numel(Results.experiments(index_experiment).screenShot)-numUselessFiles;
% 		disp(['ʵ���ļ��� ' Results.experiments(index_experiment).name ' ���ļ��� screen shot �� ' num2str(Results.experiments(index_experiment).num_screenShot) ' ���ļ�'])
% 		if Results.experiments(index_experiment).num_screenShot ~=0
% 			for index_screenShot = 1:Results.experiments(index_experiment).num_screenShot
% 				Results.experiments(index_experiment).screenShot(index_screenShot).path = fullfile(Results.experiments(index_experiment).folderpath_screenShot, Results.experiments(index_experiment).screenShot(index_screenShot).name);
% 			end
% 		else
% 			disp(['�ļ��� ' Results.experiments(index_experiment).folderpath_screenShot ' û�н��ͼ�ļ�...']);
% 		end
		
% 		%% ��������ļ���·��
% 		Results.experiments(index_experiment).folderpath_writeData = fullfile(Results.experiments(index_experiment).path, 'write data');
% 		if ~exist(Results.experiments(index_experiment).folderpath_writeData,'dir')
% 			mkdir(Results.experiments(index_experiment).folderpath_writeData);
% 		end
% 		% ÿ����������ļ����ƺ�·��
% 		Results.experiments(index_experiment).writeData = dir([Results.experiments(index_experiment).folderpath_writeData '\*.mat']);
% 		Results.experiments(index_experiment).num_writeData = numel(Results.experiments(index_experiment).writeData );
% 		disp(['ʵ���ļ��� ' Results.experiments(index_experiment).name ' ���ļ��� write data �� ' num2str(Results.experiments(index_experiment).num_writeData) ' ���ļ�'])
% 		if Results.experiments(index_experiment).num_writeData ~=0
% 			for index_writeData = 1:Results.experiments(index_experiment).num_writeData
% 				Results.experiments(index_experiment).writeData(index_writeData).path = fullfile(Results.experiments(index_experiment).folderpath_writeData, Results.experiments(index_experiment).writeData(index_writeData).name);
% 			end
% 		else
% 			disp(['�ļ��� ' Results.experiments(index_experiment).folderpath_writeData ' û����������ļ�...']);
% 		end
		
		
% 		%% �������ֵ���ݵ��ļ���·��
% 		Results.experiments(index_experiment).folderpath_evaluationData = fullfile(Results.experiments(index_experiment).path, 'evaluation data');
% 		if ~exist(Results.experiments(index_experiment).folderpath_evaluationData,'dir')
% 			mkdir(Results.experiments(index_experiment).folderpath_evaluationData);
% 		end
% 		Results.experiments(index_experiment).evaluationData = dir([Results.experiments(index_experiment).folderpath_evaluationData '\*.mat']);
% 		Results.experiments(index_experiment).num_evaluationData = numel(Results.experiments(index_experiment).evaluationData );
% 		disp(['ʵ���ļ��� ' Results.experiments(index_experiment).name ' ���ļ��� evaluation data �� ' num2str(Results.experiments(index_experiment).num_evaluationData) ' ���ļ�'])
% 		if Results.experiments(index_experiment).num_evaluationData ~=0
% 			for index_evaluationData = 1:Results.experiments(index_experiment).num_evaluationData
% 				Results.experiments(index_experiment).evaluationData(index_evaluationData).path = fullfile(Results.experiments(index_experiment).folderpath_evaluationData, Results.experiments(index_experiment).evaluationData(index_evaluationData).name);
% 			end
% 		else
% 			disp(['�ļ��� ' Results.experiments(index_experiment).folderpath_writeData ' û����������ļ�...']);
% 		end
		
		
		
	end % end experiment loop
	
end % end if

end

