classdef createDataStructure
    %CREATEEACHIMAGESSTRUCTURE 此处显示有关此类的摘要
    %   input:
    % numUselessFiles：要减去的无用的文件数。针对Windows系统的图像文件夹里的文件“Thumbs.db”
    % output:
    % Results：返回一个结构体
    
    properties
        
    end
    
    methods
        
        
        function [ EachImage ] = createEachImageStructure(baseFolder, numUselessFiles)
            %createEachImageStructure 创建结构体EachImage。
            %   input:
            % numUselessFiles：要减去的无用的文件数。针对Windows系统的图像文件夹里的文件“Thumbs.db”
            % output:
            % EachImage：返回一个结构体
            
            
            %% 构建文件夹的资源resources 结构体EachImage
            EachImage.folderpath_datasets =[ baseFolder ];	% 基本路径
            if ~exist(EachImage.folderpath_datasets,'dir')
                mkdir(EachImage.folderpath_datasets);
            end
            
            % % 文件夹 datasets 里的所有文件夹
            % EachImage.folders = dir(EachImage.folderpath_datasets);
            % EachImage.folders(1:2,:)=[];
            % EachImage.num_folders=numel(EachImage.folders);
            % for index_eachFolder =1:EachImage.num_folders
            % 	EachImage.folders(index_eachFolder).path = fullfile(EachImage.folderpath_datasets, EachImage.folders(index_eachFolder).name);
            % 	% 	if ~exist(EachImage.folderpath_originalImages ,'dir')
            % 	% 		mkdir(EachImage.folderpath_originalImages );
            % 	% 	end
            % 	% 获取每一个子文件夹的图像的名称信息
            % 	EachImage.folders(index_eachFolder).files=dir([EachImage.folders(index_eachFolder).path]);
            % 	EachImage.folders(index_eachFolder).files(1:2,:)=[];
            % 	EachImage.num_file(index_eachFolder) = numel(EachImage.folders(index_eachFolder).files)-numUselessFiles; % 有时候，文件夹会出现 "Thumbs.db"，需要考虑去掉 "Thumbs.db"
            % 	% 每一个子文件夹里的图像路径
            % 	for index_eachImage=1:EachImage.num_file(index_eachFolder)
            % 		EachImage.folders(index_eachFolder).files(index_eachImage).path=fullfile(EachImage.folders(index_eachFolder).path, EachImage.folders(index_eachFolder).files(index_eachImage).name);	% 每个原始图像文件夹的路径
            % 	end
            % end
            %
            % % 文件夹 datasets 里的所有文件夹
            % EachImage.folders = dir(EachImage.folderpath_datasets);
            % EachImage.folders(1:2,:)=[];
            % EachImage.num_folders=numel(EachImage.folders);
            % for index_eachFolder =1:EachImage.num_folders
            % 	EachImage.folders(index_eachFolder).path = fullfile(EachImage.folderpath_datasets, EachImage.folders(index_eachFolder).name);
            % 	% 	if ~exist(EachImage.folderpath_originalImages ,'dir')
            % 	% 		mkdir(EachImage.folderpath_originalImages );
            % 	% 	end
            % 	% 获取每一个子文件夹的图像的名称信息
            % 	EachImage.folders(index_eachFolder).files=dir([EachImage.folders(index_eachFolder).path]);
            % 	EachImage.folders(index_eachFolder).files(1:2,:)=[];
            % 	EachImage.num_file(index_eachFolder) = numel(EachImage.bwData(index_eachFolder).files)-numUselessFiles; % 有时候，文件夹会出现 "Thumbs.db"，需要考虑去掉 "Thumbs.db"
            % 	% 每一个子文件夹里的图像路径
            % 	for index_eachImage=1:EachImage.num_file(index_eachFolder)
            % 		EachImage.folders(index_eachFolder).files(index_eachImage).path=fullfile(EachImage.folders(index_eachFolder).path, EachImage.folders(index_eachFolder).files(index_eachImage).name);	% 每个原始图像文件夹的路径
            % 	end
            % end
            
            % %% 文件夹 bw data 的信息
            % EachImage.folderpath_bwData = fullfile(EachImage.folderpath_datasets, 'bw data');
            % if ~exist(EachImage.folderpath_bwData,'dir')
            % 	mkdir(EachImage.folderpath_bwData);
            % end
            % % 获取每一个子文件夹的最终二值图数据信息
            % EachImage.bwData = dir([EachImage.folderpath_bwData '\*.mat']);
            % EachImage.num_bwData = numel(EachImage.bwData);
            % disp(['文件夹 bw data 有 ' num2str(EachImage.num_bwData) ' 个文件'])
            % if EachImage.num_bwData ~=0
            % 	for index_bwData = 1:EachImage.num_bwData
            % 		EachImage.bwData(index_bwData).path = fullfile(EachImage.folderpath_bwData, EachImage.bwData(index_bwData).name);
            % 	end
            % else
            % 	disp(['文件夹 ' EachImage.folderpath_bwData ' 没有最终二值图数据文件...']);
            % end
            %
            % %% 文件夹 bw images 的信息
            % EachImage.folderpath_bwImage = fullfile(EachImage.folderpath_datasets, 'bw images');
            % if ~exist(EachImage.folderpath_bwImage,'dir')
            % 	mkdir(EachImage.folderpath_bwImage);
            % end
            % % 获取每一个子文件夹的最终二值图截图信息
            % EachImage.bwImage = dir([EachImage.folderpath_bwImage '\*.bmp']);
            % EachImage.num_bwImage= numel(EachImage.bwImage)-numUselessFiles;
            % disp(['文件夹 bw images 有 ' num2str(EachImage.num_bwImage) ' 个文件'])
            % if EachImage.num_bwImage ~=0
            % 	for index_bwImage = 1:EachImage.num_bwImage
            % 		EachImage.bwImage(index_bwImage).path = fullfile(EachImage.folderpath_bwImage, EachImage.bwImage(index_bwImage).name);
            % 	end
            % else
            % 	disp(['文件夹 ' EachImage.folderpath_bwImage ' 没有最终二值图截图文件...']);
            % end
            
            %% 文件夹 contour images 的信息
            EachImage.folderpath_contourImage = fullfile(EachImage.folderpath_datasets, 'contour images');
            if ~exist(EachImage.folderpath_contourImage,'dir')
                mkdir(EachImage.folderpath_contourImage);
            end
            % 获取每一个子文件夹的初始轮廓轮廓二值图信息
            EachImage.contourImage = dir([EachImage.folderpath_contourImage '\*.bmp']);
            EachImage.num_contourImage= numel(EachImage.contourImage)-numUselessFiles;
            disp(['文件夹 contour images 有 ' num2str(EachImage.num_contourImage) ' 个文件'])
            if EachImage.num_contourImage ~=0
                for index_contourImage = 1:EachImage.num_contourImage
                    EachImage.contourImage(index_contourImage).path = fullfile(EachImage.folderpath_contourImage, EachImage.contourImage(index_contourImage).name);
                end
            else
                disp(['文件夹 ' EachImage.folderpath_contourImage ' 没有初始轮廓二值图截图文件...']);
            end
            
            %% 文件夹初始 phi 的信息
            EachImage.folderpath_phi = fullfile(EachImage.folderpath_datasets, 'phi');
            if ~exist(EachImage.folderpath_phi,'dir')
                mkdir(EachImage.folderpath_phi);
            end
            % 获取每一个子文件夹的初始轮廓协方差信息
            EachImage.phi = dir([EachImage.folderpath_phi '\*.mat']);
            EachImage.num_phi= numel(EachImage.phi)-numUselessFiles;
            disp(['文件夹 phi 有 ' num2str(EachImage.num_phi) ' 个文件'])
            if EachImage.num_phi~=0
                for index_phi= 1:EachImage.num_phi
                    EachImage.phi(index_phi).path = fullfile(EachImage.folderpath_phi, EachImage.phi(index_phi).name);
                end
            else
                disp(['文件夹 ' EachImage.folderpath_phi ' 没有初始水平集嵌入函数文件...']);
            end
            
            %% 文件夹初始 time 的信息
            EachImage.folderpath_time = fullfile(EachImage.folderpath_datasets, 'time');
            if ~exist(EachImage.folderpath_time,'dir')
                mkdir(EachImage.folderpath_time);
            end
            % 获取每一个子文件夹的初始轮廓协方差信息
            EachImage.time = dir([EachImage.folderpath_time '\*.mat']);
            EachImage.num_time= numel(EachImage.time)-numUselessFiles;
            disp(['文件夹 time 有 ' num2str(EachImage.num_time) ' 个文件'])
            if EachImage.num_time ~=0
                for index_time = 1:EachImage.num_time
                    EachImage.time(index_time).path = fullfile(EachImage.folderpath_time, EachImage.time(index_time).name);
                end
            else
                disp(['文件夹 ' EachImage.folderpath_time ' 没有初始耗费时间文件...']);
            end
            
            %% 文件夹 prior 的信息
            EachImage.folderpath_prior = fullfile(EachImage.folderpath_datasets, 'prior');
            if ~exist(EachImage.folderpath_prior,'dir')
                mkdir(EachImage.folderpath_prior);
            end
            % 获取每一个子文件夹的初始轮廓先验值信息
            EachImage.prior = dir([EachImage.folderpath_prior '\*.mat']);
            EachImage.num_prior= numel(EachImage.prior)-numUselessFiles;
            disp(['文件夹 prior 有 ' num2str(EachImage.num_prior) ' 个文件'])
            if EachImage.num_prior ~=0
                for index_prior = 1:EachImage.num_prior
                    EachImage.prior(index_prior).path = fullfile(EachImage.folderpath_prior, EachImage.prior(index_prior).name);
                end
            else
                disp(['文件夹 ' EachImage.folderpath_prior ' 没有初始轮廓先验值文件...']);
            end
            
            %% 文件夹 mu 的信息
            EachImage.folderpath_mu = fullfile(EachImage.folderpath_datasets, 'mu');
            if ~exist(EachImage.folderpath_mu,'dir')
                mkdir(EachImage.folderpath_mu);
            end
            % 获取每一个子文件夹的初始轮廓均值信息
            EachImage.mu = dir([EachImage.folderpath_mu '\*.mat']);
            EachImage.num_mu= numel(EachImage.mu)-numUselessFiles;
            disp(['文件夹 mu 有 ' num2str(EachImage.num_mu) ' 个文件'])
            if EachImage.num_mu ~=0
                for index_mu = 1:EachImage.num_mu
                    EachImage.mu(index_mu).path = fullfile(EachImage.folderpath_mu, EachImage.mu(index_mu).name);
                end
            else
                disp(['文件夹 ' EachImage.folderpath_mu ' 没有初始轮廓均值文件...']);
            end
            
            %% 文件夹 Sigma 的信息
            EachImage.folderpath_Sigma = fullfile(EachImage.folderpath_datasets, 'Sigma');
            if ~exist(EachImage.folderpath_Sigma,'dir')
                mkdir(EachImage.folderpath_Sigma);
            end
            % 获取每一个子文件夹的初始轮廓协方差信息
            EachImage.Sigma = dir([EachImage.folderpath_Sigma '\*.mat']);
            EachImage.num_Sigma= numel(EachImage.Sigma)-numUselessFiles;
            disp(['文件夹 Sigma 有 ' num2str(EachImage.num_Sigma) ' 个文件'])
            if EachImage.num_Sigma ~=0
                for index_Sigma = 1:EachImage.num_Sigma
                    EachImage.Sigma(index_Sigma).path = fullfile(EachImage.folderpath_Sigma, EachImage.Sigma(index_Sigma).name);
                end
            else
                disp(['文件夹 ' EachImage.folderpath_Sigma ' 没有初始轮廓协方差文件...']);
            end
            
            
            
            %% 文件夹 ground truth bw images 的信息
            EachImage.folderpath_groundTruthBwImage = fullfile(EachImage.folderpath_datasets, 'ground truth bw images');
            if ~exist(EachImage.folderpath_groundTruthBwImage,'dir')
                mkdir(EachImage.folderpath_groundTruthBwImage);
            end
            % 获取每一个子文件夹的答案二值图截图信息
            EachImage.groundTruthBwImage = dir([EachImage.folderpath_groundTruthBwImage '\*.bmp']);
            EachImage.num_groundTruthBwImage= numel(EachImage.groundTruthBwImage)-numUselessFiles;
            disp(['文件夹 ground truth bw images 有 ' num2str(EachImage.num_groundTruthBwImage) ' 个文件'])
            if EachImage.num_groundTruthBwImage ~=0
                for index_groundTruthBwImage = 1:EachImage.num_groundTruthBwImage
                    EachImage.groundTruthBwImage(index_groundTruthBwImage).path = fullfile(EachImage.folderpath_groundTruthBwImage, EachImage.groundTruthBwImage(index_groundTruthBwImage).name);
                end
            else
                disp(['文件夹 ' EachImage.folderpath_groundTruthBwImage ' 没有答案二值图截图文件...']);
            end
            
            %% 文件夹 original images 的信息
            EachImage.folderpath_originalImage = fullfile(EachImage.folderpath_datasets, 'original images');
            if ~exist(EachImage.folderpath_originalImage,'dir')
                mkdir(EachImage.folderpath_originalImage);
            end
            % 获取每一个子文件夹的原始图像信息
            EachImage.originalImage = dir([EachImage.folderpath_originalImage '\*.jpg']);
            EachImage.num_originalImage= numel(EachImage.originalImage)-numUselessFiles;
            disp(['文件夹 original images 有 ' num2str(EachImage.num_originalImage) ' 个文件'])
            if EachImage.num_originalImage ~=0
                for index_originalImage = 1:EachImage.num_originalImage
                    EachImage.originalImage(index_originalImage).path = fullfile(EachImage.folderpath_originalImage, EachImage.originalImage(index_originalImage).name);
                end
            else
                disp(['文件夹 ' EachImage.folderpath_originalImage ' 没有原始图像文件...']);
            end
            
            %% 文件夹 scribbled images 的信息
            EachImage.folderpath_scribbledImage = fullfile(EachImage.folderpath_datasets, 'scribbled images');
            if ~exist(EachImage.folderpath_scribbledImage,'dir')
                mkdir(EachImage.folderpath_scribbledImage);
            end
            % 获取每一个子文件夹的带标记的原始图像文件信息
            EachImage.scribbledImage = dir([EachImage.folderpath_scribbledImage '\*.bmp']);
            EachImage.num_scribbledImage= numel(EachImage.scribbledImage)-numUselessFiles;
            disp(['文件夹 scribbled images 有 ' num2str(EachImage.num_scribbledImage) ' 个文件'])
            if EachImage.num_scribbledImage ~=0
                for index_scribbledImage = 1:EachImage.num_scribbledImage
                    EachImage.scribbledImage(index_scribbledImage).path = fullfile(EachImage.folderpath_scribbledImage, EachImage.scribbledImage(index_scribbledImage).name);
                end
            else
                disp(['文件夹 ' EachImage.folderpath_scribbledImage ' 没有带标记的原始图像文件...']);
            end
            
            
        end
        
        
    end
    
end

