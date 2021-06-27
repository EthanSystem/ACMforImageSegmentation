function [ EachImage ] = createInitializedResourceStructure( resourcesBaseFolder, numUselessFiles )
%CREATE 此处显示有关此函数的摘要
%   此处显示详细说明
% createInitializedResourceStructure 创建结构体EachImage。
%   input:
% numUselessFiles：要减去的无用的文件数。针对Windows系统的图像文件夹里的文件“Thumbs.db”
% output:
% EachImage：返回一个结构体


%% 构建文件夹的资源resources 结构体EachImage
EachImage.folderpath_reourcesDatasets =[ resourcesBaseFolder ];	  % 基础资源文件（原图、真值图、标记图）的基本路径


%% 文件夹 contour images 的信息
EachImage.folderpath_contourImage = fullfile(EachImage.folderpath_initDatasets, 'contour images');
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
EachImage.folderpath_phi = fullfile(EachImage.folderpath_initDatasets, 'phi');
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
EachImage.folderpath_time = fullfile(EachImage.folderpath_initDatasets, 'time');
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
EachImage.folderpath_prior = fullfile(EachImage.folderpath_initDatasets, 'prior');
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
EachImage.folderpath_mu = fullfile(EachImage.folderpath_initDatasets, 'mu');
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
EachImage.folderpath_Sigma = fullfile(EachImage.folderpath_initDatasets, 'Sigma');
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







end

