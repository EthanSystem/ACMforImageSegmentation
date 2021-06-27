function [ EachImage ] = createEachImageStructure(resourcesBaseFolder, folderpath_initMethodBase, numUselessFiles)
%createEachImageStructure 创建结构体EachImage。
%   input:
% numUselessFiles：要减去的无用的文件数。针对Windows系统的图像文件夹里的文件“Thumbs.db”
% output:
% EachImage：返回一个结构体


%% 构建文件夹的资源 resources 结构体 EachImage
EachImage.folderpath_originalReources =[ resourcesBaseFolder ];	  % 基础资源文件（原图、真值图、标记图）的基本路径
EachImage.folderpath_initMethods =[ folderpath_initMethodBase ];	% 基础初始化文件（各种初始化方法生成的如初始轮廓二值图、各参数、时间参数等）的基本路径
% if ~exist(EachImage.folderpath_datasets,'dir')


%% 构建文件夹的原始资源 original resources 部分

%% 文件夹 original images 的信息
EachImage.folderpath_originalImage = fullfile(EachImage.folderpath_originalReources, 'original images');
if ~exist(EachImage.folderpath_originalImage,'dir')
    mkdir(EachImage.folderpath_originalImage);
end
% 获取每一个子文件夹的原始图像信息
EachImage.originalImage = dir([EachImage.folderpath_originalImage '\*.jpg']);
EachImage.num_originalImage= numel(EachImage.originalImage)-numUselessFiles;
disp(['文件夹 original images 有 ' num2str(EachImage.num_originalImage) ' 个文件'])
if EachImage.num_originalImage ~=0
    for i = 1:EachImage.num_originalImage
        EachImage.originalImage(i).path = fullfile(EachImage.folderpath_originalImage, EachImage.originalImage(i).name);
    end
else
    disp(['文件夹 ' EachImage.folderpath_originalImage ' 没有原始图像文件...']);
end

%% 文件夹 ground truth bw images 的信息
EachImage.folderpath_groundTruthBwImage = fullfile(EachImage.folderpath_originalReources, 'ground truth bw images');
if ~exist(EachImage.folderpath_groundTruthBwImage,'dir')
    mkdir(EachImage.folderpath_groundTruthBwImage);
end
% 获取每一个子文件夹的答案二值图截图信息
EachImage.groundTruthBwImage = dir([EachImage.folderpath_groundTruthBwImage '\*.bmp']);
EachImage.num_groundTruthBwImage= numel(EachImage.groundTruthBwImage)-numUselessFiles;
disp(['文件夹 ground truth bw images 有 ' num2str(EachImage.num_groundTruthBwImage) ' 个文件'])
if EachImage.num_groundTruthBwImage ~=0
    for i = 1:EachImage.num_groundTruthBwImage
        EachImage.groundTruthBwImage(i).path = fullfile(EachImage.folderpath_groundTruthBwImage, EachImage.groundTruthBwImage(i).name);
    end
else
    disp(['文件夹 ' EachImage.folderpath_groundTruthBwImage ' 没有答案二值图截图文件...']);
end

%% 文件夹 scribbled images 的信息
EachImage.folderpath_scribbledImage = fullfile(EachImage.folderpath_originalReources, 'scribbled images');
if ~exist(EachImage.folderpath_scribbledImage,'dir')
    mkdir(EachImage.folderpath_scribbledImage);
end
% 获取每一个子文件夹的带标记的原始图像文件信息
EachImage.scribbledImage = dir([EachImage.folderpath_scribbledImage '\*.bmp']);
EachImage.num_scribbledImage= numel(EachImage.scribbledImage)-numUselessFiles;
disp(['文件夹 scribbled images 有 ' num2str(EachImage.num_scribbledImage) ' 个文件'])
if EachImage.num_scribbledImage ~=0
    for i = 1:EachImage.num_scribbledImage
        EachImage.scribbledImage(i).path = fullfile(EachImage.folderpath_scribbledImage, EachImage.scribbledImage(i).name);
    end
else
    disp(['文件夹 ' EachImage.folderpath_scribbledImage ' 没有带标记的原始图像文件...']);
end

%% seedsIndex1 文件夹路径
EachImage.folderpath_seedsIndex1 = fullfile(EachImage.folderpath_originalReources, 'seedsIndex1');
if ~exist(EachImage.folderpath_seedsIndex1,'dir')
    mkdir(EachImage.folderpath_seedsIndex1);
end
% 每个seedsIndex1名称和路径
EachImage.seedsIndex1= dir([EachImage.folderpath_seedsIndex1 '\*.mat']);
EachImage.num_seedsIndex1 = numel(EachImage.seedsIndex1)-numUselessFiles;
if EachImage.num_seedsIndex1 ~=0
    for i= 1:EachImage.num_seedsIndex1
        EachImage.seedsIndex1(i).path = fullfile(EachImage.folderpath_seedsIndex1, EachImage.seedsIndex1(i).name);
    end
else
    disp(['文件夹 ' EachImage.folderpath_seedsIndex1 ' 没有 seeds index 1 文件...']);
end

%% seedsIndex2 文件夹路径
EachImage.folderpath_seedsIndex2 = fullfile(EachImage.folderpath_originalReources, 'seedsIndex2');
if ~exist(EachImage.folderpath_seedsIndex2,'dir')
    mkdir(EachImage.folderpath_seedsIndex2);
end
% 每个seedsIndex2名称和路径
EachImage.seedsIndex2= dir([EachImage.folderpath_seedsIndex2 '\*.mat']);
EachImage.num_seedsIndex2 = numel(EachImage.seedsIndex2)-numUselessFiles;
if EachImage.num_seedsIndex2 ~=0
    for i= 1:EachImage.num_seedsIndex2
        EachImage.seedsIndex2(i).path = fullfile(EachImage.folderpath_seedsIndex2, EachImage.seedsIndex2(i).name);
    end
else
    disp(['文件夹 ' EachImage.folderpath_seedsIndex2 ' 没有 seeds index 2 文件...']);
end

%% seeds1 文件夹路径
EachImage.folderpath_seeds1 = fullfile(EachImage.folderpath_originalReources, 'seeds1');
if ~exist(EachImage.folderpath_seeds1,'dir')
    mkdir(EachImage.folderpath_seeds1);
end
% 每个seeds1名称和路径
EachImage.seeds1= dir([EachImage.folderpath_seeds1 '\*.mat']);
EachImage.num_seeds1 = numel(EachImage.seeds1)-numUselessFiles;
if EachImage.num_seeds1 ~=0
    for i= 1:EachImage.num_seeds1
        EachImage.seeds1(i).path = fullfile(EachImage.folderpath_seeds1, EachImage.seeds1(i).name);
    end
else
    disp(['文件夹 ' EachImage.folderpath_seeds1 ' 没有 seeds 1 文件...']);
end

%% seeds2 文件夹路径
EachImage.folderpath_seeds2 = fullfile(EachImage.folderpath_originalReources, 'seeds2');
if ~exist(EachImage.folderpath_seeds2,'dir')
    mkdir(EachImage.folderpath_seeds2);
end
% 每个seeds2名称和路径
EachImage.seeds2= dir([EachImage.folderpath_seeds2 '\*.mat']);
EachImage.num_seeds2 = numel(EachImage.seeds2)-numUselessFiles;
if EachImage.num_seeds2 ~=0
    for i= 1:EachImage.num_seeds2
        EachImage.seeds2(i).path = fullfile(EachImage.folderpath_seeds2, EachImage.seeds2(i).name);
    end
else
    disp(['文件夹 ' EachImage.folderpath_seeds2 ' 没有 seeds 2 文件...']);
end

%% seedsImg1 文件夹路径
EachImage.folderpath_seedsImg1 = fullfile(EachImage.folderpath_originalReources, 'seedsImg1');
if ~exist(EachImage.folderpath_seedsImg1,'dir')
    mkdir(EachImage.folderpath_seedsImg1);
end
% 每个seedsImg1名称和路径
EachImage.seedsImg1= dir([EachImage.folderpath_seedsImg1 '\*.bmp']);
EachImage.num_seedsImg1 = numel(EachImage.seedsImg1)-numUselessFiles;
if EachImage.num_seedsImg1 ~=0
    for i= 1:EachImage.num_seedsImg1
        EachImage.seedsImg1(i).path = fullfile(EachImage.folderpath_seedsImg1, EachImage.seedsImg1(i).name);
    end
else
    disp(['文件夹 ' EachImage.folderpath_seedsImg1 ' 没有 seeds image 1 文件...']);
end

%% seedsImg2 文件夹路径
EachImage.folderpath_seedsImg2 = fullfile(EachImage.folderpath_originalReources, 'seedsImg2');
if ~exist(EachImage.folderpath_seedsImg2,'dir')
    mkdir(EachImage.folderpath_seedsImg2);
end
% 每个seedsImg2名称和路径
EachImage.seedsImg2= dir([EachImage.folderpath_seedsImg2 '\*.bmp']);
EachImage.num_seedsImg2 = numel(EachImage.seedsImg2)-numUselessFiles;
if EachImage.num_seedsImg2 ~=0
    for i= 1:EachImage.num_seedsImg2
        EachImage.seedsImg2(i).path = fullfile(EachImage.folderpath_seedsImg2, EachImage.seedsImg2(i).name);
    end
else
    disp(['文件夹 ' EachImage.folderpath_seedsImg2 ' 没有 seeds image 2 文件...']);
end


%% 构建文件夹的各个初始化方法的初始资源 init resources 部分

EachImage.folderpath_initMethodBase = [ folderpath_initMethodBase ];
EachImage.initMethods=dir(EachImage.folderpath_initMethodBase); % 每种初始化方法的文件夹列表
EachImage.initMethods(1:2,:)=[];
EachImage.num_initMethods=numel(EachImage.initMethods);

if EachImage.num_initMethods~=0
    for index_initMethod = 1:EachImage.num_initMethods
        %% 指定各初始化方法的文件夹
        EachImage.initMethods(index_initMethod).folderpath = fullfile(EachImage.folderpath_initMethodBase, EachImage.initMethods(index_initMethod).name) ;
        
        %% 文件夹 contour images 的信息
        EachImage.initMethods(index_initMethod).folderpath_contourImage = fullfile(EachImage.initMethods(index_initMethod).folderpath, 'contour images');
        if ~exist(EachImage.initMethods(index_initMethod).folderpath_contourImage,'dir')
            mkdir(EachImage.initMethods(index_initMethod).folderpath_contourImage);
        end
        % 获取每一个子文件夹的初始轮廓轮廓二值图信息
        EachImage.initMethods(index_initMethod).contourImage = dir([EachImage.initMethods(index_initMethod).folderpath_contourImage '\*.bmp']);
        EachImage.initMethods(index_initMethod).num_contourImage= numel(EachImage.initMethods(index_initMethod).contourImage)-numUselessFiles;
        disp(['初始化方法文件夹 ' EachImage.initMethods(index_initMethod).name ' 有 ' num2str(EachImage.initMethods(index_initMethod).num_contourImage) ' 个初始轮廓轮廓二值图文件'])
        if EachImage.initMethods(index_initMethod).num_contourImage ~=0
            for index_contourImage = 1:EachImage.initMethods(index_initMethod).num_contourImage
                EachImage.initMethods(index_initMethod).contourImage(index_contourImage).path = fullfile(EachImage.initMethods(index_initMethod).folderpath_contourImage, EachImage.initMethods(index_initMethod).contourImage(index_contourImage).name);
            end
        else
            disp(['文件夹 ' EachImage.initMethods(index_initMethod).folderpath_contourImage ' 没有初始轮廓二值图截图文件...']);
        end
        
        %% 文件夹初始 phi 的信息
        EachImage.initMethods(index_initMethod).folderpath_phi = fullfile(EachImage.initMethods(index_initMethod).folderpath, 'phi');
        if ~exist(EachImage.initMethods(index_initMethod).folderpath_phi,'dir')
            mkdir(EachImage.initMethods(index_initMethod).folderpath_phi);
        end
        % 获取每一个子文件夹的初始 phi 信息
        EachImage.initMethods(index_initMethod).phi = dir([EachImage.initMethods(index_initMethod).folderpath_phi '\*.mat']);
        EachImage.initMethods(index_initMethod).num_phi= numel(EachImage.initMethods(index_initMethod).phi)-numUselessFiles;
        disp(['初始化方法文件夹 ' EachImage.initMethods(index_initMethod).name ' 有 ' num2str(EachImage.initMethods(index_initMethod).num_phi) ' 个初始 phi 文件'])
        if EachImage.initMethods(index_initMethod).num_phi~=0
            for index_phi= 1:EachImage.initMethods(index_initMethod).num_phi
                EachImage.initMethods(index_initMethod).phi(index_phi).path = fullfile(EachImage.initMethods(index_initMethod).folderpath_phi, EachImage.initMethods(index_initMethod).phi(index_phi).name);
            end
        else
            disp(['文件夹 ' EachImage.initMethods(index_initMethod).folderpath_phi ' 没有初始 phi 文件...']);
        end
        
        %% 文件夹初始 time 的信息
        EachImage.initMethods(index_initMethod).folderpath_time = fullfile(EachImage.initMethods(index_initMethod).folderpath, 'time');
        if ~exist(EachImage.initMethods(index_initMethod).folderpath_time,'dir')
            mkdir(EachImage.initMethods(index_initMethod).folderpath_time);
        end
        % 获取每一个子文件夹的初始轮廓协方差信息
        EachImage.initMethods(index_initMethod).time = dir([EachImage.initMethods(index_initMethod).folderpath_time '\*.mat']);
        EachImage.initMethods(index_initMethod).num_time= numel(EachImage.initMethods(index_initMethod).time)-numUselessFiles;
        disp(['初始化方法文件夹 ' EachImage.initMethods(index_initMethod).name ' 有 ' num2str(EachImage.initMethods(index_initMethod).num_time) ' 个初始耗费时间文件'])
        if EachImage.initMethods(index_initMethod).num_time ~=0
            for index_time = 1:EachImage.initMethods(index_initMethod).num_time
                EachImage.initMethods(index_initMethod).time(index_time).path = fullfile(EachImage.initMethods(index_initMethod).folderpath_time, EachImage.initMethods(index_initMethod).time(index_time).name);
            end
        else
            disp(['文件夹 ' EachImage.initMethods(index_initMethod).folderpath_time ' 没有初始耗费时间文件...']);
        end
        
        %% 文件夹 prior 的信息
        EachImage.initMethods(index_initMethod).folderpath_prior = fullfile(EachImage.initMethods(index_initMethod).folderpath, 'prior');
        if ~exist(EachImage.initMethods(index_initMethod).folderpath_prior,'dir')
            mkdir(EachImage.initMethods(index_initMethod).folderpath_prior);
        end
        % 获取每一个子文件夹的初始轮廓先验值信息
        EachImage.initMethods(index_initMethod).prior = dir([EachImage.initMethods(index_initMethod).folderpath_prior '\*.mat']);
        EachImage.initMethods(index_initMethod).num_prior= numel(EachImage.initMethods(index_initMethod).prior)-numUselessFiles;
        disp(['初始化方法文件夹 ' EachImage.initMethods(index_initMethod).name ' 有 ' num2str(EachImage.initMethods(index_initMethod).num_prior) ' 个初始轮廓先验值文件'])
        if EachImage.initMethods(index_initMethod).num_prior ~=0
            for index_prior = 1:EachImage.initMethods(index_initMethod).num_prior
                EachImage.initMethods(index_initMethod).prior(index_prior).path = fullfile(EachImage.initMethods(index_initMethod).folderpath_prior, EachImage.initMethods(index_initMethod).prior(index_prior).name);
            end
        else
            disp(['文件夹 ' EachImage.initMethods(index_initMethod).folderpath_prior ' 没有初始轮廓先验值文件...']);
        end
        
        %% 文件夹 mu 的信息
        EachImage.initMethods(index_initMethod).folderpath_mu = fullfile(EachImage.initMethods(index_initMethod).folderpath, 'mu');
        if ~exist(EachImage.initMethods(index_initMethod).folderpath_mu,'dir')
            mkdir(EachImage.initMethods(index_initMethod).folderpath_mu);
        end
        % 获取每一个子文件夹的初始轮廓均值信息
        EachImage.initMethods(index_initMethod).mu = dir([EachImage.initMethods(index_initMethod).folderpath_mu '\*.mat']);
        EachImage.initMethods(index_initMethod).num_mu= numel(EachImage.initMethods(index_initMethod).mu)-numUselessFiles;
        disp(['初始化方法文件夹 ' EachImage.initMethods(index_initMethod).name ' 有 ' num2str(EachImage.initMethods(index_initMethod).num_mu) ' 个初始轮廓均值文件'])
        if EachImage.initMethods(index_initMethod).num_mu ~=0
            for index_mu = 1:EachImage.initMethods(index_initMethod).num_mu
                EachImage.initMethods(index_initMethod).mu(index_mu).path = fullfile(EachImage.initMethods(index_initMethod).folderpath_mu, EachImage.initMethods(index_initMethod).mu(index_mu).name);
            end
        else
            disp(['文件夹 ' EachImage.initMethods(index_initMethod).folderpath_mu ' 没有初始轮廓均值文件...']);
        end
        
        %% 文件夹 Sigma 的信息
        EachImage.initMethods(index_initMethod).folderpath_Sigma = fullfile(EachImage.initMethods(index_initMethod).folderpath, 'Sigma');
        if ~exist(EachImage.initMethods(index_initMethod).folderpath_Sigma,'dir')
            mkdir(EachImage.initMethods(index_initMethod).folderpath_Sigma);
        end
        % 获取每一个子文件夹的初始轮廓协方差信息
        EachImage.initMethods(index_initMethod).Sigma = dir([EachImage.initMethods(index_initMethod).folderpath_Sigma '\*.mat']);
        EachImage.initMethods(index_initMethod).num_Sigma= numel(EachImage.initMethods(index_initMethod).Sigma)-numUselessFiles;
        disp(['初始化方法文件夹 ' EachImage.initMethods(index_initMethod).name ' 有 ' num2str(EachImage.initMethods(index_initMethod).num_Sigma) ' 个初始轮廓协方差文件'])
        if EachImage.initMethods(index_initMethod).num_Sigma ~=0
            for index_Sigma = 1:EachImage.initMethods(index_initMethod).num_Sigma
                EachImage.initMethods(index_initMethod).Sigma(index_Sigma).path = fullfile(EachImage.initMethods(index_initMethod).folderpath_Sigma, EachImage.initMethods(index_initMethod).Sigma(index_Sigma).name);
            end
        else
            disp(['文件夹 ' EachImage.initMethods(index_initMethod).folderpath_Sigma ' 没有初始轮廓协方差文件...']);
        end
        
        %% 文件夹初始 Args 的信息
        EachImage.initMethods(index_initMethod).folderpath_Args = fullfile(EachImage.initMethods(index_initMethod).folderpath, 'Args');
        if ~exist(EachImage.initMethods(index_initMethod).folderpath_Args,'dir')
            mkdir(EachImage.initMethods(index_initMethod).folderpath_Args);
        end
        % 获取每一个子文件夹的初始轮廓 Args 信息
        EachImage.initMethods(index_initMethod).Args = dir([EachImage.initMethods(index_initMethod).folderpath_Args '\*.mat']);
        EachImage.initMethods(index_initMethod).num_Args= numel(EachImage.initMethods(index_initMethod).Args)-numUselessFiles;
        disp(['初始化方法文件夹 ' EachImage.initMethods(index_initMethod).name ' 有 ' num2str(EachImage.initMethods(index_initMethod).num_Args) ' 个 Args 文件'])
        if EachImage.initMethods(index_initMethod).num_Args~=0
            for index_Args= 1:EachImage.initMethods(index_initMethod).num_Args
                EachImage.initMethods(index_initMethod).Args(index_Args).path = fullfile(EachImage.initMethods(index_initMethod).folderpath_Args, EachImage.initMethods(index_initMethod).Args(index_Args).name);
            end
        else
            disp(['文件夹 ' EachImage.initMethods(index_initMethod).folderpath_Args ' 没有 Args 文件...']);
        end
        
        
        
        
    end   % end init methods loop
end % end if



end

