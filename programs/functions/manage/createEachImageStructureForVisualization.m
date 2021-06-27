function [ EachImage ] = createEachImageStructureForVisualization(resourcesBaseFolder, initBaseFolder, numUselessFiles)
%createEachImageStructure 创建结构体EachImage。
%   input:
% numUselessFiles：要减去的无用的文件数。针对Windows系统的图像文件夹里的文件“Thumbs.db”
% output:
% EachImage：返回一个结构体


%% 构建文件夹的资源resources 结构体EachImage
EachImage.folderpath_originalReources =[ resourcesBaseFolder ];	  % 基础资源文件（原图、真值图、标记图）的基本路径
EachImage.folderpath_initResources =[ initBaseFolder ];	% 基础初始化文件（各种初始化方法生成的如初始轮廓二值图、各参数、时间参数等）的基本路径
% if ~exist(EachImage.folderpath_datasets,'dir')
%     mkdir(EachImage.folderpath_datasets);
% end



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
    for index_groundTruthBwImage = 1:EachImage.num_groundTruthBwImage
        EachImage.groundTruthBwImage(index_groundTruthBwImage).path = fullfile(EachImage.folderpath_groundTruthBwImage, EachImage.groundTruthBwImage(index_groundTruthBwImage).name);
    end
else
    disp(['文件夹 ' EachImage.folderpath_groundTruthBwImage ' 没有答案二值图截图文件...']);
end

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
    for index_originalImage = 1:EachImage.num_originalImage
        EachImage.originalImage(index_originalImage).path = fullfile(EachImage.folderpath_originalImage, EachImage.originalImage(index_originalImage).name);
    end
else
    disp(['文件夹 ' EachImage.folderpath_originalImage ' 没有原始图像文件...']);
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
    for index_scribbledImage = 1:EachImage.num_scribbledImage
        EachImage.scribbledImage(index_scribbledImage).path = fullfile(EachImage.folderpath_scribbledImage, EachImage.scribbledImage(index_scribbledImage).name);
    end
else
    disp(['文件夹 ' EachImage.folderpath_scribbledImage ' 没有带标记的原始图像文件...']);
end

%% seedsIndex1 文件夹路径
% EachImage.folderpath_seedsIndex1 = fullfile(EachImage.folderpath_originalReources, 'seedsIndex1');
% if ~exist(EachImage.folderpath_seedsIndex1,'dir')
%     mkdir(EachImage.folderpath_seedsIndex1);
% end
% % 每个seedsIndex1名称和路径
% EachImage.seedsIndex1= dir([EachImage.folderpath_seedsIndex1 '\*.mat']);
% EachImage.num_seedsIndex1 = numel(EachImage.seedsIndex1)-numUselessFiles;
% if EachImage.num_seedsIndex1 ~=0
%     for i= 1:EachImage.num_seedsIndex1
%         EachImage.seedsIndex1(i).path = fullfile(EachImage.folderpath_seedsIndex1, EachImage.seedsIndex1(i).name);
%     end
% end

%% seedsIndex2 文件夹路径
% EachImage.folderpath_seedsIndex2 = fullfile(EachImage.folderpath_originalReources, 'seedsIndex2');
% if ~exist(EachImage.folderpath_seedsIndex2,'dir')
%     mkdir(EachImage.folderpath_seedsIndex2);
% end
% % 每个seedsIndex2名称和路径
% EachImage.seedsIndex2= dir([EachImage.folderpath_seedsIndex2 '\*.mat']);
% EachImage.num_seedsIndex2 = numel(EachImage.seedsIndex2)-numUselessFiles;
% if EachImage.num_seedsIndex2 ~=0
%     for i= 1:EachImage.num_seedsIndex2
%         EachImage.seedsIndex2(i).path = fullfile(EachImage.folderpath_seedsIndex2, EachImage.seedsIndex2(i).name);
%     end
% end

%% seeds1 文件夹路径
% EachImage.folderpath_seeds1 = fullfile(EachImage.folderpath_originalReources, 'seeds1');
% if ~exist(EachImage.folderpath_seeds1,'dir')
%     mkdir(EachImage.folderpath_seeds1);
% end
% % 每个seeds1名称和路径
% EachImage.seeds1= dir([EachImage.folderpath_seeds1 '\*.mat']);
% EachImage.num_seeds1 = numel(EachImage.seeds1)-numUselessFiles;
% if EachImage.num_seeds1 ~=0
%     for i= 1:EachImage.num_seeds1
%         EachImage.seeds1(i).path = fullfile(EachImage.folderpath_seeds1, EachImage.seeds1(i).name);
%     end
% end

%% seeds2 文件夹路径
% EachImage.folderpath_seeds2 = fullfile(EachImage.folderpath_originalReources, 'seeds2');
% if ~exist(EachImage.folderpath_seeds2,'dir')
%     mkdir(EachImage.folderpath_seeds2);
% end
% % 每个seeds2名称和路径
% EachImage.seeds2= dir([EachImage.folderpath_seeds2 '\*.mat']);
% EachImage.num_seeds2 = numel(EachImage.seeds2)-numUselessFiles;
% if EachImage.num_seeds2 ~=0
%     for i= 1:EachImage.num_seeds2
%         EachImage.seeds2(i).path = fullfile(EachImage.folderpath_seeds2, EachImage.seeds2(i).name);
%     end
% end

%% seedsImg1 文件夹路径
% EachImage.folderpath_seedsImg1 = fullfile(EachImage.folderpath_originalReources, 'seedsImg1');
% if ~exist(EachImage.folderpath_seedsImg1,'dir')
%     mkdir(EachImage.folderpath_seedsImg1);
% end
% % 每个seedsImg1名称和路径
% EachImage.seedsImg1= dir([EachImage.folderpath_seedsImg1 '\*.bmp']);
% EachImage.num_seedsImg1 = numel(EachImage.seedsImg1)-numUselessFiles;
% if EachImage.num_seedsImg1 ~=0
%     for i= 1:EachImage.num_seedsImg1
%         EachImage.seedsImg1(i).path = fullfile(EachImage.folderpath_seedsImg1, EachImage.seedsImg1(i).name);
%     end
% end

%% seedsImg2 文件夹路径
% EachImage.folderpath_seedsImg2 = fullfile(EachImage.folderpath_originalReources, 'seedsImg2');
% if ~exist(EachImage.folderpath_seedsImg2,'dir')
%     mkdir(EachImage.folderpath_seedsImg2);
% end
% % 每个seedsImg2名称和路径
% EachImage.seedsImg2= dir([EachImage.folderpath_seedsImg2 '\*.bmp']);
% EachImage.num_seedsImg2 = numel(EachImage.seedsImg2)-numUselessFiles;
% if EachImage.num_seedsImg2 ~=0
%     for i= 1:EachImage.num_seedsImg2
%         EachImage.seedsImg2(i).path = fullfile(EachImage.folderpath_seedsImg2, EachImage.seedsImg2(i).name);
%     end
% end







%% 文件夹 contour images 的信息
% EachImage.folderpath_contourImage = fullfile(EachImage.folderpath_initResources, 'contour images');
% if ~exist(EachImage.folderpath_contourImage,'dir')
%     mkdir(EachImage.folderpath_contourImage);
% end
% % 获取每一个子文件夹的初始轮廓轮廓二值图信息
% EachImage.contourImage = dir([EachImage.folderpath_contourImage '\*.bmp']);
% EachImage.num_contourImage= numel(EachImage.contourImage)-numUselessFiles;
% disp(['文件夹 contour images 有 ' num2str(EachImage.num_contourImage) ' 个文件'])
% if EachImage.num_contourImage ~=0
%     for index_contourImage = 1:EachImage.num_contourImage
%         EachImage.contourImage(index_contourImage).path = fullfile(EachImage.folderpath_contourImage, EachImage.contourImage(index_contourImage).name);
%     end
% else
%     disp(['文件夹 ' EachImage.folderpath_contourImage ' 没有初始轮廓二值图截图文件...']);
% end

%% 文件夹初始 phi 的信息
% EachImage.folderpath_phi = fullfile(EachImage.folderpath_initResources, 'phi');
% if ~exist(EachImage.folderpath_phi,'dir')
%     mkdir(EachImage.folderpath_phi);
% end
% % 获取每一个子文件夹的初始轮廓协方差信息
% EachImage.phi = dir([EachImage.folderpath_phi '\*.mat']);
% EachImage.num_phi= numel(EachImage.phi)-numUselessFiles;
% disp(['文件夹 phi 有 ' num2str(EachImage.num_phi) ' 个文件'])
% if EachImage.num_phi~=0
%     for index_phi= 1:EachImage.num_phi
%         EachImage.phi(index_phi).path = fullfile(EachImage.folderpath_phi, EachImage.phi(index_phi).name);
%     end
% else
%     disp(['文件夹 ' EachImage.folderpath_phi ' 没有初始水平集嵌入函数文件...']);
% end

%% 文件夹初始 time 的信息
% EachImage.folderpath_time = fullfile(EachImage.folderpath_initResources, 'time');
% if ~exist(EachImage.folderpath_time,'dir')
%     mkdir(EachImage.folderpath_time);
% end
% % 获取每一个子文件夹的初始轮廓协方差信息
% EachImage.time = dir([EachImage.folderpath_time '\*.mat']);
% EachImage.num_time= numel(EachImage.time)-numUselessFiles;
% disp(['文件夹 time 有 ' num2str(EachImage.num_time) ' 个文件'])
% if EachImage.num_time ~=0
%     for index_time = 1:EachImage.num_time
%         EachImage.time(index_time).path = fullfile(EachImage.folderpath_time, EachImage.time(index_time).name);
%     end
% else
%     disp(['文件夹 ' EachImage.folderpath_time ' 没有初始耗费时间文件...']);
% end

%% 文件夹 prior 的信息
% EachImage.folderpath_prior = fullfile(EachImage.folderpath_initResources, 'prior');
% if ~exist(EachImage.folderpath_prior,'dir')
%     mkdir(EachImage.folderpath_prior);
% end
% % 获取每一个子文件夹的初始轮廓先验值信息
% EachImage.prior = dir([EachImage.folderpath_prior '\*.mat']);
% EachImage.num_prior= numel(EachImage.prior)-numUselessFiles;
% disp(['文件夹 prior 有 ' num2str(EachImage.num_prior) ' 个文件'])
% if EachImage.num_prior ~=0
%     for index_prior = 1:EachImage.num_prior
%         EachImage.prior(index_prior).path = fullfile(EachImage.folderpath_prior, EachImage.prior(index_prior).name);
%     end
% else
%     disp(['文件夹 ' EachImage.folderpath_prior ' 没有初始轮廓先验值文件...']);
% end

%% 文件夹 mu 的信息
% EachImage.folderpath_mu = fullfile(EachImage.folderpath_initResources, 'mu');
% if ~exist(EachImage.folderpath_mu,'dir')
%     mkdir(EachImage.folderpath_mu);
% end
% % 获取每一个子文件夹的初始轮廓均值信息
% EachImage.mu = dir([EachImage.folderpath_mu '\*.mat']);
% EachImage.num_mu= numel(EachImage.mu)-numUselessFiles;
% disp(['文件夹 mu 有 ' num2str(EachImage.num_mu) ' 个文件'])
% if EachImage.num_mu ~=0
%     for index_mu = 1:EachImage.num_mu
%         EachImage.mu(index_mu).path = fullfile(EachImage.folderpath_mu, EachImage.mu(index_mu).name);
%     end
% else
%     disp(['文件夹 ' EachImage.folderpath_mu ' 没有初始轮廓均值文件...']);
% end

%% 文件夹 Sigma 的信息
% EachImage.folderpath_Sigma = fullfile(EachImage.folderpath_initResources, 'Sigma');
% if ~exist(EachImage.folderpath_Sigma,'dir')
%     mkdir(EachImage.folderpath_Sigma);
% end
% % 获取每一个子文件夹的初始轮廓协方差信息
% EachImage.Sigma = dir([EachImage.folderpath_Sigma '\*.mat']);
% EachImage.num_Sigma= numel(EachImage.Sigma)-numUselessFiles;
% disp(['文件夹 Sigma 有 ' num2str(EachImage.num_Sigma) ' 个文件'])
% if EachImage.num_Sigma ~=0
%     for index_Sigma = 1:EachImage.num_Sigma
%         EachImage.Sigma(index_Sigma).path = fullfile(EachImage.folderpath_Sigma, EachImage.Sigma(index_Sigma).name);
%     end
% else
%     disp(['文件夹 ' EachImage.folderpath_Sigma ' 没有初始轮廓协方差文件...']);
% end

%% 文件夹初始 Args 的信息
% EachImage.folderpath_Args = fullfile(EachImage.folderpath_initResources, 'Args');
% if ~exist(EachImage.folderpath_Args,'dir')
%     mkdir(EachImage.folderpath_Args);
% end
% % 获取每一个子文件夹的初始轮廓 Args 信息
% EachImage.Args = dir([EachImage.folderpath_Args '\*.mat']);
% EachImage.num_Args= numel(EachImage.Args)-numUselessFiles;
% disp(['文件夹 Args 有 ' num2str(EachImage.num_Args) ' 个文件'])
% if EachImage.num_Args~=0
%     for index_Args= 1:EachImage.num_Args
%         EachImage.Args(index_Args).path = fullfile(EachImage.folderpath_Args, EachImage.Args(index_Args).name);
%     end
% else
%     disp(['文件夹 ' EachImage.folderpath_Args ' 没有 Args 文件...']);
% end




end

