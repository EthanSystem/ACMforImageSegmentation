classdef createDataStructure
    %CREATEEACHIMAGESSTRUCTURE �˴���ʾ�йش����ժҪ
    %   input:
    % numUselessFiles��Ҫ��ȥ�����õ��ļ��������Windowsϵͳ��ͼ���ļ�������ļ���Thumbs.db��
    % output:
    % Results������һ���ṹ��
    
    properties
        
    end
    
    methods
        
        
        function [ EachImage ] = createEachImageStructure(baseFolder, numUselessFiles)
            %createEachImageStructure �����ṹ��EachImage��
            %   input:
            % numUselessFiles��Ҫ��ȥ�����õ��ļ��������Windowsϵͳ��ͼ���ļ�������ļ���Thumbs.db��
            % output:
            % EachImage������һ���ṹ��
            
            
            %% �����ļ��е���Դresources �ṹ��EachImage
            EachImage.folderpath_datasets =[ baseFolder ];	% ����·��
            if ~exist(EachImage.folderpath_datasets,'dir')
                mkdir(EachImage.folderpath_datasets);
            end
            
            % % �ļ��� datasets ��������ļ���
            % EachImage.folders = dir(EachImage.folderpath_datasets);
            % EachImage.folders(1:2,:)=[];
            % EachImage.num_folders=numel(EachImage.folders);
            % for index_eachFolder =1:EachImage.num_folders
            % 	EachImage.folders(index_eachFolder).path = fullfile(EachImage.folderpath_datasets, EachImage.folders(index_eachFolder).name);
            % 	% 	if ~exist(EachImage.folderpath_originalImages ,'dir')
            % 	% 		mkdir(EachImage.folderpath_originalImages );
            % 	% 	end
            % 	% ��ȡÿһ�����ļ��е�ͼ���������Ϣ
            % 	EachImage.folders(index_eachFolder).files=dir([EachImage.folders(index_eachFolder).path]);
            % 	EachImage.folders(index_eachFolder).files(1:2,:)=[];
            % 	EachImage.num_file(index_eachFolder) = numel(EachImage.folders(index_eachFolder).files)-numUselessFiles; % ��ʱ���ļ��л���� "Thumbs.db"����Ҫ����ȥ�� "Thumbs.db"
            % 	% ÿһ�����ļ������ͼ��·��
            % 	for index_eachImage=1:EachImage.num_file(index_eachFolder)
            % 		EachImage.folders(index_eachFolder).files(index_eachImage).path=fullfile(EachImage.folders(index_eachFolder).path, EachImage.folders(index_eachFolder).files(index_eachImage).name);	% ÿ��ԭʼͼ���ļ��е�·��
            % 	end
            % end
            %
            % % �ļ��� datasets ��������ļ���
            % EachImage.folders = dir(EachImage.folderpath_datasets);
            % EachImage.folders(1:2,:)=[];
            % EachImage.num_folders=numel(EachImage.folders);
            % for index_eachFolder =1:EachImage.num_folders
            % 	EachImage.folders(index_eachFolder).path = fullfile(EachImage.folderpath_datasets, EachImage.folders(index_eachFolder).name);
            % 	% 	if ~exist(EachImage.folderpath_originalImages ,'dir')
            % 	% 		mkdir(EachImage.folderpath_originalImages );
            % 	% 	end
            % 	% ��ȡÿһ�����ļ��е�ͼ���������Ϣ
            % 	EachImage.folders(index_eachFolder).files=dir([EachImage.folders(index_eachFolder).path]);
            % 	EachImage.folders(index_eachFolder).files(1:2,:)=[];
            % 	EachImage.num_file(index_eachFolder) = numel(EachImage.bwData(index_eachFolder).files)-numUselessFiles; % ��ʱ���ļ��л���� "Thumbs.db"����Ҫ����ȥ�� "Thumbs.db"
            % 	% ÿһ�����ļ������ͼ��·��
            % 	for index_eachImage=1:EachImage.num_file(index_eachFolder)
            % 		EachImage.folders(index_eachFolder).files(index_eachImage).path=fullfile(EachImage.folders(index_eachFolder).path, EachImage.folders(index_eachFolder).files(index_eachImage).name);	% ÿ��ԭʼͼ���ļ��е�·��
            % 	end
            % end
            
            % %% �ļ��� bw data ����Ϣ
            % EachImage.folderpath_bwData = fullfile(EachImage.folderpath_datasets, 'bw data');
            % if ~exist(EachImage.folderpath_bwData,'dir')
            % 	mkdir(EachImage.folderpath_bwData);
            % end
            % % ��ȡÿһ�����ļ��е����ն�ֵͼ������Ϣ
            % EachImage.bwData = dir([EachImage.folderpath_bwData '\*.mat']);
            % EachImage.num_bwData = numel(EachImage.bwData);
            % disp(['�ļ��� bw data �� ' num2str(EachImage.num_bwData) ' ���ļ�'])
            % if EachImage.num_bwData ~=0
            % 	for index_bwData = 1:EachImage.num_bwData
            % 		EachImage.bwData(index_bwData).path = fullfile(EachImage.folderpath_bwData, EachImage.bwData(index_bwData).name);
            % 	end
            % else
            % 	disp(['�ļ��� ' EachImage.folderpath_bwData ' û�����ն�ֵͼ�����ļ�...']);
            % end
            %
            % %% �ļ��� bw images ����Ϣ
            % EachImage.folderpath_bwImage = fullfile(EachImage.folderpath_datasets, 'bw images');
            % if ~exist(EachImage.folderpath_bwImage,'dir')
            % 	mkdir(EachImage.folderpath_bwImage);
            % end
            % % ��ȡÿһ�����ļ��е����ն�ֵͼ��ͼ��Ϣ
            % EachImage.bwImage = dir([EachImage.folderpath_bwImage '\*.bmp']);
            % EachImage.num_bwImage= numel(EachImage.bwImage)-numUselessFiles;
            % disp(['�ļ��� bw images �� ' num2str(EachImage.num_bwImage) ' ���ļ�'])
            % if EachImage.num_bwImage ~=0
            % 	for index_bwImage = 1:EachImage.num_bwImage
            % 		EachImage.bwImage(index_bwImage).path = fullfile(EachImage.folderpath_bwImage, EachImage.bwImage(index_bwImage).name);
            % 	end
            % else
            % 	disp(['�ļ��� ' EachImage.folderpath_bwImage ' û�����ն�ֵͼ��ͼ�ļ�...']);
            % end
            
            %% �ļ��� contour images ����Ϣ
            EachImage.folderpath_contourImage = fullfile(EachImage.folderpath_datasets, 'contour images');
            if ~exist(EachImage.folderpath_contourImage,'dir')
                mkdir(EachImage.folderpath_contourImage);
            end
            % ��ȡÿһ�����ļ��еĳ�ʼ����������ֵͼ��Ϣ
            EachImage.contourImage = dir([EachImage.folderpath_contourImage '\*.bmp']);
            EachImage.num_contourImage= numel(EachImage.contourImage)-numUselessFiles;
            disp(['�ļ��� contour images �� ' num2str(EachImage.num_contourImage) ' ���ļ�'])
            if EachImage.num_contourImage ~=0
                for index_contourImage = 1:EachImage.num_contourImage
                    EachImage.contourImage(index_contourImage).path = fullfile(EachImage.folderpath_contourImage, EachImage.contourImage(index_contourImage).name);
                end
            else
                disp(['�ļ��� ' EachImage.folderpath_contourImage ' û�г�ʼ������ֵͼ��ͼ�ļ�...']);
            end
            
            %% �ļ��г�ʼ phi ����Ϣ
            EachImage.folderpath_phi = fullfile(EachImage.folderpath_datasets, 'phi');
            if ~exist(EachImage.folderpath_phi,'dir')
                mkdir(EachImage.folderpath_phi);
            end
            % ��ȡÿһ�����ļ��еĳ�ʼ����Э������Ϣ
            EachImage.phi = dir([EachImage.folderpath_phi '\*.mat']);
            EachImage.num_phi= numel(EachImage.phi)-numUselessFiles;
            disp(['�ļ��� phi �� ' num2str(EachImage.num_phi) ' ���ļ�'])
            if EachImage.num_phi~=0
                for index_phi= 1:EachImage.num_phi
                    EachImage.phi(index_phi).path = fullfile(EachImage.folderpath_phi, EachImage.phi(index_phi).name);
                end
            else
                disp(['�ļ��� ' EachImage.folderpath_phi ' û�г�ʼˮƽ��Ƕ�뺯���ļ�...']);
            end
            
            %% �ļ��г�ʼ time ����Ϣ
            EachImage.folderpath_time = fullfile(EachImage.folderpath_datasets, 'time');
            if ~exist(EachImage.folderpath_time,'dir')
                mkdir(EachImage.folderpath_time);
            end
            % ��ȡÿһ�����ļ��еĳ�ʼ����Э������Ϣ
            EachImage.time = dir([EachImage.folderpath_time '\*.mat']);
            EachImage.num_time= numel(EachImage.time)-numUselessFiles;
            disp(['�ļ��� time �� ' num2str(EachImage.num_time) ' ���ļ�'])
            if EachImage.num_time ~=0
                for index_time = 1:EachImage.num_time
                    EachImage.time(index_time).path = fullfile(EachImage.folderpath_time, EachImage.time(index_time).name);
                end
            else
                disp(['�ļ��� ' EachImage.folderpath_time ' û�г�ʼ�ķ�ʱ���ļ�...']);
            end
            
            %% �ļ��� prior ����Ϣ
            EachImage.folderpath_prior = fullfile(EachImage.folderpath_datasets, 'prior');
            if ~exist(EachImage.folderpath_prior,'dir')
                mkdir(EachImage.folderpath_prior);
            end
            % ��ȡÿһ�����ļ��еĳ�ʼ��������ֵ��Ϣ
            EachImage.prior = dir([EachImage.folderpath_prior '\*.mat']);
            EachImage.num_prior= numel(EachImage.prior)-numUselessFiles;
            disp(['�ļ��� prior �� ' num2str(EachImage.num_prior) ' ���ļ�'])
            if EachImage.num_prior ~=0
                for index_prior = 1:EachImage.num_prior
                    EachImage.prior(index_prior).path = fullfile(EachImage.folderpath_prior, EachImage.prior(index_prior).name);
                end
            else
                disp(['�ļ��� ' EachImage.folderpath_prior ' û�г�ʼ��������ֵ�ļ�...']);
            end
            
            %% �ļ��� mu ����Ϣ
            EachImage.folderpath_mu = fullfile(EachImage.folderpath_datasets, 'mu');
            if ~exist(EachImage.folderpath_mu,'dir')
                mkdir(EachImage.folderpath_mu);
            end
            % ��ȡÿһ�����ļ��еĳ�ʼ������ֵ��Ϣ
            EachImage.mu = dir([EachImage.folderpath_mu '\*.mat']);
            EachImage.num_mu= numel(EachImage.mu)-numUselessFiles;
            disp(['�ļ��� mu �� ' num2str(EachImage.num_mu) ' ���ļ�'])
            if EachImage.num_mu ~=0
                for index_mu = 1:EachImage.num_mu
                    EachImage.mu(index_mu).path = fullfile(EachImage.folderpath_mu, EachImage.mu(index_mu).name);
                end
            else
                disp(['�ļ��� ' EachImage.folderpath_mu ' û�г�ʼ������ֵ�ļ�...']);
            end
            
            %% �ļ��� Sigma ����Ϣ
            EachImage.folderpath_Sigma = fullfile(EachImage.folderpath_datasets, 'Sigma');
            if ~exist(EachImage.folderpath_Sigma,'dir')
                mkdir(EachImage.folderpath_Sigma);
            end
            % ��ȡÿһ�����ļ��еĳ�ʼ����Э������Ϣ
            EachImage.Sigma = dir([EachImage.folderpath_Sigma '\*.mat']);
            EachImage.num_Sigma= numel(EachImage.Sigma)-numUselessFiles;
            disp(['�ļ��� Sigma �� ' num2str(EachImage.num_Sigma) ' ���ļ�'])
            if EachImage.num_Sigma ~=0
                for index_Sigma = 1:EachImage.num_Sigma
                    EachImage.Sigma(index_Sigma).path = fullfile(EachImage.folderpath_Sigma, EachImage.Sigma(index_Sigma).name);
                end
            else
                disp(['�ļ��� ' EachImage.folderpath_Sigma ' û�г�ʼ����Э�����ļ�...']);
            end
            
            
            
            %% �ļ��� ground truth bw images ����Ϣ
            EachImage.folderpath_groundTruthBwImage = fullfile(EachImage.folderpath_datasets, 'ground truth bw images');
            if ~exist(EachImage.folderpath_groundTruthBwImage,'dir')
                mkdir(EachImage.folderpath_groundTruthBwImage);
            end
            % ��ȡÿһ�����ļ��еĴ𰸶�ֵͼ��ͼ��Ϣ
            EachImage.groundTruthBwImage = dir([EachImage.folderpath_groundTruthBwImage '\*.bmp']);
            EachImage.num_groundTruthBwImage= numel(EachImage.groundTruthBwImage)-numUselessFiles;
            disp(['�ļ��� ground truth bw images �� ' num2str(EachImage.num_groundTruthBwImage) ' ���ļ�'])
            if EachImage.num_groundTruthBwImage ~=0
                for index_groundTruthBwImage = 1:EachImage.num_groundTruthBwImage
                    EachImage.groundTruthBwImage(index_groundTruthBwImage).path = fullfile(EachImage.folderpath_groundTruthBwImage, EachImage.groundTruthBwImage(index_groundTruthBwImage).name);
                end
            else
                disp(['�ļ��� ' EachImage.folderpath_groundTruthBwImage ' û�д𰸶�ֵͼ��ͼ�ļ�...']);
            end
            
            %% �ļ��� original images ����Ϣ
            EachImage.folderpath_originalImage = fullfile(EachImage.folderpath_datasets, 'original images');
            if ~exist(EachImage.folderpath_originalImage,'dir')
                mkdir(EachImage.folderpath_originalImage);
            end
            % ��ȡÿһ�����ļ��е�ԭʼͼ����Ϣ
            EachImage.originalImage = dir([EachImage.folderpath_originalImage '\*.jpg']);
            EachImage.num_originalImage= numel(EachImage.originalImage)-numUselessFiles;
            disp(['�ļ��� original images �� ' num2str(EachImage.num_originalImage) ' ���ļ�'])
            if EachImage.num_originalImage ~=0
                for index_originalImage = 1:EachImage.num_originalImage
                    EachImage.originalImage(index_originalImage).path = fullfile(EachImage.folderpath_originalImage, EachImage.originalImage(index_originalImage).name);
                end
            else
                disp(['�ļ��� ' EachImage.folderpath_originalImage ' û��ԭʼͼ���ļ�...']);
            end
            
            %% �ļ��� scribbled images ����Ϣ
            EachImage.folderpath_scribbledImage = fullfile(EachImage.folderpath_datasets, 'scribbled images');
            if ~exist(EachImage.folderpath_scribbledImage,'dir')
                mkdir(EachImage.folderpath_scribbledImage);
            end
            % ��ȡÿһ�����ļ��еĴ���ǵ�ԭʼͼ���ļ���Ϣ
            EachImage.scribbledImage = dir([EachImage.folderpath_scribbledImage '\*.bmp']);
            EachImage.num_scribbledImage= numel(EachImage.scribbledImage)-numUselessFiles;
            disp(['�ļ��� scribbled images �� ' num2str(EachImage.num_scribbledImage) ' ���ļ�'])
            if EachImage.num_scribbledImage ~=0
                for index_scribbledImage = 1:EachImage.num_scribbledImage
                    EachImage.scribbledImage(index_scribbledImage).path = fullfile(EachImage.folderpath_scribbledImage, EachImage.scribbledImage(index_scribbledImage).name);
                end
            else
                disp(['�ļ��� ' EachImage.folderpath_scribbledImage ' û�д���ǵ�ԭʼͼ���ļ�...']);
            end
            
            
        end
        
        
    end
    
end

