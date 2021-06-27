function [ EachImage ] = createOriginalResourceStructure( resourcesBaseFolder, numUselessFiles )
%CREATE 此处显示有关此函数的摘要
%   此处显示详细说明
% createOriginalResourceStructure 创建结构体EachImage。
%   input:
% numUselessFiles：要减去的无用的文件数。针对Windows系统的图像文件夹里的文件“Thumbs.db”
% output:
% EachImage：返回一个结构体


%% 构建文件夹的资源resources 结构体EachImage
EachImage.folderpath_reourcesDatasets =[ resourcesBaseFolder ];	  % 基础资源文件（原图、真值图、标记图）的基本路径


%% 文件夹 ground truth bw images 的信息
EachImage.folderpath_groundTruthBwImage = fullfile(EachImage.folderpath_reourcesDatasets, 'ground truth bw images');
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
EachImage.folderpath_originalImage = fullfile(EachImage.folderpath_reourcesDatasets, 'original images');
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
EachImage.folderpath_scribbledImage = fullfile(EachImage.folderpath_reourcesDatasets, 'scribbled images');
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

%% seedsIndex1 文件夹路径
EachImage.folderpath_seedsIndex1 = fullfile(EachImage.folderpath_reourcesDatasets, 'seedsIndex1');
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
end

%% seedsIndex2 文件夹路径
EachImage.folderpath_seedsIndex2 = fullfile(EachImage.folderpath_reourcesDatasets, 'seedsIndex2');
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
end

%% seeds1 文件夹路径
EachImage.folderpath_seeds1 = fullfile(EachImage.folderpath_reourcesDatasets, 'seeds1');
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
end

%% seeds2 文件夹路径
EachImage.folderpath_seeds2 = fullfile(EachImage.folderpath_reourcesDatasets, 'seeds2');
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
end

%% seedsImg1 文件夹路径
EachImage.folderpath_seedsImg1 = fullfile(EachImage.folderpath_reourcesDatasets, 'seedsImg1');
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
end

%% seedsImg2 文件夹路径
EachImage.folderpath_seedsImg2 = fullfile(EachImage.folderpath_reourcesDatasets, 'seedsImg2');
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
end






end

