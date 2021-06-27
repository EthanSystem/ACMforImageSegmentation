function [ EachImage ] = createOriginalResourceStructure( resourcesBaseFolder, numUselessFiles )
%CREATE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
% createOriginalResourceStructure �����ṹ��EachImage��
%   input:
% numUselessFiles��Ҫ��ȥ�����õ��ļ��������Windowsϵͳ��ͼ���ļ�������ļ���Thumbs.db��
% output:
% EachImage������һ���ṹ��


%% �����ļ��е���Դresources �ṹ��EachImage
EachImage.folderpath_reourcesDatasets =[ resourcesBaseFolder ];	  % ������Դ�ļ���ԭͼ����ֵͼ�����ͼ���Ļ���·��


%% �ļ��� ground truth bw images ����Ϣ
EachImage.folderpath_groundTruthBwImage = fullfile(EachImage.folderpath_reourcesDatasets, 'ground truth bw images');
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
EachImage.folderpath_originalImage = fullfile(EachImage.folderpath_reourcesDatasets, 'original images');
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
EachImage.folderpath_scribbledImage = fullfile(EachImage.folderpath_reourcesDatasets, 'scribbled images');
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

%% seedsIndex1 �ļ���·��
EachImage.folderpath_seedsIndex1 = fullfile(EachImage.folderpath_reourcesDatasets, 'seedsIndex1');
if ~exist(EachImage.folderpath_seedsIndex1,'dir')
    mkdir(EachImage.folderpath_seedsIndex1);
end
% ÿ��seedsIndex1���ƺ�·��
EachImage.seedsIndex1= dir([EachImage.folderpath_seedsIndex1 '\*.mat']);
EachImage.num_seedsIndex1 = numel(EachImage.seedsIndex1)-numUselessFiles;
if EachImage.num_seedsIndex1 ~=0
    for i= 1:EachImage.num_seedsIndex1
        EachImage.seedsIndex1(i).path = fullfile(EachImage.folderpath_seedsIndex1, EachImage.seedsIndex1(i).name);
    end
end

%% seedsIndex2 �ļ���·��
EachImage.folderpath_seedsIndex2 = fullfile(EachImage.folderpath_reourcesDatasets, 'seedsIndex2');
if ~exist(EachImage.folderpath_seedsIndex2,'dir')
    mkdir(EachImage.folderpath_seedsIndex2);
end
% ÿ��seedsIndex2���ƺ�·��
EachImage.seedsIndex2= dir([EachImage.folderpath_seedsIndex2 '\*.mat']);
EachImage.num_seedsIndex2 = numel(EachImage.seedsIndex2)-numUselessFiles;
if EachImage.num_seedsIndex2 ~=0
    for i= 1:EachImage.num_seedsIndex2
        EachImage.seedsIndex2(i).path = fullfile(EachImage.folderpath_seedsIndex2, EachImage.seedsIndex2(i).name);
    end
end

%% seeds1 �ļ���·��
EachImage.folderpath_seeds1 = fullfile(EachImage.folderpath_reourcesDatasets, 'seeds1');
if ~exist(EachImage.folderpath_seeds1,'dir')
    mkdir(EachImage.folderpath_seeds1);
end
% ÿ��seeds1���ƺ�·��
EachImage.seeds1= dir([EachImage.folderpath_seeds1 '\*.mat']);
EachImage.num_seeds1 = numel(EachImage.seeds1)-numUselessFiles;
if EachImage.num_seeds1 ~=0
    for i= 1:EachImage.num_seeds1
        EachImage.seeds1(i).path = fullfile(EachImage.folderpath_seeds1, EachImage.seeds1(i).name);
    end
end

%% seeds2 �ļ���·��
EachImage.folderpath_seeds2 = fullfile(EachImage.folderpath_reourcesDatasets, 'seeds2');
if ~exist(EachImage.folderpath_seeds2,'dir')
    mkdir(EachImage.folderpath_seeds2);
end
% ÿ��seeds2���ƺ�·��
EachImage.seeds2= dir([EachImage.folderpath_seeds2 '\*.mat']);
EachImage.num_seeds2 = numel(EachImage.seeds2)-numUselessFiles;
if EachImage.num_seeds2 ~=0
    for i= 1:EachImage.num_seeds2
        EachImage.seeds2(i).path = fullfile(EachImage.folderpath_seeds2, EachImage.seeds2(i).name);
    end
end

%% seedsImg1 �ļ���·��
EachImage.folderpath_seedsImg1 = fullfile(EachImage.folderpath_reourcesDatasets, 'seedsImg1');
if ~exist(EachImage.folderpath_seedsImg1,'dir')
    mkdir(EachImage.folderpath_seedsImg1);
end
% ÿ��seedsImg1���ƺ�·��
EachImage.seedsImg1= dir([EachImage.folderpath_seedsImg1 '\*.bmp']);
EachImage.num_seedsImg1 = numel(EachImage.seedsImg1)-numUselessFiles;
if EachImage.num_seedsImg1 ~=0
    for i= 1:EachImage.num_seedsImg1
        EachImage.seedsImg1(i).path = fullfile(EachImage.folderpath_seedsImg1, EachImage.seedsImg1(i).name);
    end
end

%% seedsImg2 �ļ���·��
EachImage.folderpath_seedsImg2 = fullfile(EachImage.folderpath_reourcesDatasets, 'seedsImg2');
if ~exist(EachImage.folderpath_seedsImg2,'dir')
    mkdir(EachImage.folderpath_seedsImg2);
end
% ÿ��seedsImg2���ƺ�·��
EachImage.seedsImg2= dir([EachImage.folderpath_seedsImg2 '\*.bmp']);
EachImage.num_seedsImg2 = numel(EachImage.seedsImg2)-numUselessFiles;
if EachImage.num_seedsImg2 ~=0
    for i= 1:EachImage.num_seedsImg2
        EachImage.seedsImg2(i).path = fullfile(EachImage.folderpath_seedsImg2, EachImage.seedsImg2(i).name);
    end
end






end

