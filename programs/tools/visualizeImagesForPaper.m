%% 简介
% visualizeImagesForPaper.m 可视化需要的图像用于论文展示。
% mode = '1' 表示每种方法的各个图像的二值图集中展示，每一行表示一组图像，每组图像有原图、真值图、各方法的二值图；
% mode = '2' 表示每种方法的各个图像的二值图集中展示，每一列表示一组图像，每组图像有原图、真值图、各方法的二值图，是 mode = '1' 的转置
% mode = '3' 绘制不同代数的二值图用于对比，可以用自定义的排列方式编排文件夹。
% mode = '4' 是 mode = '3' 的转置
% mode = '5' 绘制不同代数的二值图用于对比。

%% 预处理
clear all;
close all;
clc;
diary off;
sp=actxserver('SAPI.SpVoice');


%% 用户输入初始参数 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Args.mode = '2' ;


Args.folderpath_outputBase = '.\data\expr2_analysis\expr2_analysis_semiACMGMM_毕业论文前后背景差别小的\exportForPaper'; % 指定用于输出的文件夹的基本路径。

Args.outputMode = 'datatime';	 % 指定存放这次实验的文件夹的文件名称显示类型。可选 'datatime' 'index'。'datatime' 表示实验文件夹名称是日期时间；'index'表示实验文件夹名称是编号。默认 'datatime'。推荐用默认值。Args.num_scribble = 1; % 所有待处理的图像的标记总数。由于目前暂时不考虑不同标记对分割效果的影响，而仅仅用一张图像一种标记，因此目前手动设置为1。
Args.isVisual = 'off' ;  % 绘制过程不可视化，程序结束后自行查看结果。 'on'表示绘制过程中可视化 ，'off'表示绘制过程中不可视化。默认'off'
Args.numUselessFiles = 0; % 要排除的文件数量。有时候存储图片的文件夹除了有图像文件，还有可能是系统文件会被误处理，因此需要手动排除。
Args.numImagesShow = 15 ; % 每张fig要展示的图像组的数量。

% 用于 mode '1' '2'
Args.folderpath_reourcesDatasets = '.\data\expr2_analysis\expr2_analysis_semiACMGMM_毕业论文前后背景差别小的\original resources'; % 用于计算文件的结构体 EachImage 的基本路径
% 其实 folderpath_initBaseFolder 在实际使用中不重要，随便设置一个就可以了。
Args.folderpath_initBaseFolder = '.\data\expr2_analysis\expr2_analysis_semiACMGMM_毕业论文前后背景差别小的\init resources'; % 用于计算文件的结构体 EachImage 的基本路径
Args.folderpath_ResultsBaseFolder = '.\data\expr2_analysis\expr2_analysis_semiACMGMM_毕业论文前后背景差别小的\calculation'; % 用于计算文件的结构体 Results 的基本路径。
Args.isOriginalImages = 'yes'; % 是否绘制原图
Args.isGTImages = 'yes'; % 是否绘制真值图
Args.isScribbledImages = 'no'; % 是否绘制标记图
% Args.foldersWhoIsOriginal=[1];      % 装了原图的文件夹序号
% Args.foldersWhoIsScribbled=[2];           % 装了标记图的文件夹序号
% Args.foldersWhoIsGtImage=[3];      % 装了真值二值图的文件夹序号
% Args.foldersWhoIsBwImage=[4:6];      % 装了结果二值图的文件夹序号

% 用于 mode '3' '4'
Args.folderpath_customeInput = '.\data\extract\5images'; % 用于计算文件的根路径
Args.foldersWhoIsOriginal=[1];      % 装了原图的文件夹序号
Args.foldersWhoIsScribbled=[2];           % 装了标记图的文件夹序号
Args.foldersWhoIsBwImage=[];      % 装了结果二值图的文件夹序号
Args.foldersWhoIsGtImage=[];      % 装了真值二值图的文件夹序号
Args.foldersWhoNeedColormap = [3:6];       % 装了需要做colormap处理的文件夹序号（这里特指特征向量图）
Args.foldersWhoNeedScale = [3];         % 装了需要做尺寸调整的文件夹序号
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%% properties
Pros = Args;

%% 构建文件夹的资源resources 结构体EachImage，构建results文件夹里指定做的指标的文件路径和名称的结构体 Results
EachImage = createEachImageStructure(Pros.folderpath_reourcesDatasets, Pros.folderpath_initBaseFolder, Pros.numUselessFiles);
Results = createResultsStructure(Pros.folderpath_ResultsBaseFolder, Pros.numUselessFiles);

% Pros.indexOfScribbledImageFolder = findIndexOfFolderName(EachImage, 'scribbled images');
% Pros.indexOfOriginalImageFolder = findIndexOfFolderName(EachImage, 'original images');
% Pros.indexOfBwDataFolder = findIndexOfFolderName(EachImage, 'bw data');
% Pros.indexOfBwImagesFolder = findIndexOfFolderName(EachImage, 'bw images');
% Pros.indexOfGTFolder = findIndexOfFolderName(EachImage, 'ground truth images');
% Pros.indexOfEvaluationsFolder = findIndexOfFolderName(EachImage, 'evaluations');
% Pros.indexOfFiguresFolder = findIndexOfFolderName(EachImage, 'figures');

input('确认文件夹里的文件数量是否正确？正确按任意键继续，否则按 Ctrl+c 终止程序。')

%% 构建本次评价的可视化的文件夹，并进行可视化
switch Args.outputMode
    case 'datatime'
        % 建立一个名称为年月日时分秒的数据文件夹用于每一次的实验的输出
        Pros.foldername_experiment=[datestr(now,'dd-HHMMSS') '_evaluationAnalyse'];
    case 'index'
        Pros.foldername_experiment = ['第' num2str(index_experiment) '次实验'];
end
Pros.folderpath_experiment=fullfile(Pros.folderpath_outputBase, Pros.foldername_experiment);
mkdir(Pros.folderpath_experiment);

% properties
Pros.num_scribble =1; % 标记的数量。目前不考虑不同的标记对实验结果的影响，因此设置为1
% 要处理的原始图像数量。有时候存储图片的文件夹除了有图像文件，还有可能是系统文件会被误处理，因此需要手动排除
Pros.num_originalImage = EachImage.num_originalImage;
Pros.num_experiments = Results.num_experiments;

% 确定除了实验文件夹以外，还有哪些文件夹参与绘制
num_noExperimentsFolders = 0;
if (1==strcmp(Pros.isOriginalImages,'yes'))
    num_noExperimentsFolders=num_noExperimentsFolders+1;
end
if (1==strcmp(Pros.isGTImages,'yes'))
    num_noExperimentsFolders=num_noExperimentsFolders+1;
end
if (1==strcmp(Pros.isScribbledImages,'yes'))
    num_noExperimentsFolders=num_noExperimentsFolders+1;
end

% %% 记录日志
% % 生成diary输出文件夹
% Pros.filename_diary = 'diary evaluation analyse.txt';
% Pros.filepath_diary = fullfile(Pros.folderpath_experiment, Pros.filename_diary);
% diary(Pros.filepath_diary);
% diary on;
%

%% 计时
tic;
%% 用于 mode '1' '2' ，构建提取文件的结构
if (1==strcmp(Pros.mode,'1') || 1==strcmp(Pros.mode,'2'))
    
    % 找出图像集的所有图像的纵横尺寸的最大值
    for i=1:EachImage.num_originalImage
        image010 = imread(EachImage.originalImage(i).path);
        [sizeImage(i,1) , sizeImage(i,2) , sizeImage(i,3)] = size(image010);
    end
    sizeImage=int16(sizeImage);
    clear image010;
    
    maxSizeImage = max(sizeImage); % 每个子图（不含周边空白）的像素尺寸
    sizeBox = maxSizeImage+10; sizeBox(3)=[]; % 每个子图（含周边空白）的像素尺寸
end


%% 用于 mode '3' '4' ，构建提取文件的结构
if (1==strcmp(Pros.mode,'3') || 1==strcmp(Pros.mode,'4'))
    folderpath_sub=dir(Pros.folderpath_customeInput);
    folderpath_sub(1:2)=[];
    for i =1:length(folderpath_sub)
        folder_images{i}=dir([fullfile(folderpath_sub(i).folder,folderpath_sub(i).name) '\*']);
        folder_images{i}(1:2)=[];
    end
    
    %% 找出图像集的所有图像的纵横尺寸的最大值
    for idx_img=1:length(folder_images{Pros.foldersWhoIsOriginal(1)})
        image010 = imread(fullfile(folder_images{Pros.foldersWhoIsOriginal(1)}(idx_img).folder ,folder_images{Pros.foldersWhoIsOriginal(1)}(idx_img).name));
        [sizeImage(idx_img,1) , sizeImage(idx_img,2) , sizeImage(idx_img,3)] = size(image010);
    end
    sizeImage=int16(sizeImage);
    clear image010;
    
    maxSizeImage = max(sizeImage); % 每个子图（不含周边空白）的像素尺寸
    sizeBox = maxSizeImage+10; sizeBox(3)=[]; % 每个子图（含周边空白）的像素尺寸
    
    if ~isempty(Pros.foldersWhoNeedScale)
        for idx_folder=Pros.foldersWhoNeedScale
            for idx_img=1:length(folder_images{idx_folder})
                image050 = imread(fullfile(folder_images{idx_folder}(idx_img).folder ,folder_images{idx_folder}(idx_img).name));
                image055=imresize(image050,[sizeImage(idx_img,1) sizeImage(idx_img,2)]);
                imwrite(image055,[fullfile(folder_images{idx_folder}(idx_img).folder ,folder_images{idx_folder}(idx_img).name)]);
            end
        end
    end
end

switch Pros.mode
    %     case '1'
    %         %% mode = '1' 表示每种方法的各个图像的二值图集中展示，每一行表示一组图像，每组图像有原图、真值图、各方法的二值图；
    %
    %         % 找出图像集的所有图像的纵横尺寸的最大值
    %         for i=1:EachImage.num_originalImage
    %             image010 = imread(EachImage.originalImage(i).path);
    %             [sizeImage(i,1) , sizeImage(i,2) , sizeImage(i,3)] = size(image010);
    %         end
    %         sizeImage=int16(sizeImage);
    %         clear image010;
    %
    %         maxSizeImage = max(sizeImage); % 每个子图（不含周边空白）的像素尺寸
    %         sizeBox = maxSizeImage+10; sizeBox(3)=[]; % 每个子图（含周边空白）的像素尺寸
    %         numBox = int16([EachImage.num_originalImage, Results.num_experiments + num_noExperimentsFolders]); % 子图个数 (横向 , 纵向)
    %
    %         figure010 = repmat(0.85*ones(sizeBox.*numBox), 1,1,3); % 用二维数组描绘的超级大图 figure，灰色背景
    %
    %         pos_box = int16([1 1]); % 指向应该放置在 figure 的当前 box 的左上角位置，figure 的左上角为原点(1,1)
    %         pos_img = pos_box+5; % 指向应该放置在 figure 的当前 image 的左上角位置
    %
    %         % drawing each original image
    %         if (1==strcmp(Pros.isOriginalImages,'yes'))
    %             for idx_img = 1:EachImage.num_originalImage
    %                 image010 = double(imread(EachImage.originalImage(idx_img).path))/256;
    %                 pos_img(2) = pos_box(2)+sizeBox(2)/2-sizeImage(idx_img,2)/2;
    %                 figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
    %                 pos_box(1) = pos_box(1)+sizeImage(idx_img,1)+10;
    %                 pos_img(1) = pos_box(1);
    %             end
    %             pos_box(2) = pos_box(2)+sizeBox(2);
    %             pos_box(1) = 1;
    %             pos_img = pos_box+5;
    %         end
    %
    %         % drawing each gt-image
    %         if (1==strcmp(Pros.isGTImages,'yes'))
    %             for idx_img = 1:EachImage.num_originalImage
    %                 image010 = double(imread(EachImage.groundTruthBwImage(idx_img).path))/256;
    %                 pos_img(2) = pos_box(2)+sizeBox(2)/2-sizeImage(idx_img,2)/2;
    %                 figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
    %                 pos_box(1) = pos_box(1)+sizeImage(idx_img,1)+10;
    %                 pos_img(1) = pos_box(1);
    %             end
    %             pos_box(2) = pos_box(2)+sizeBox(2);
    %             pos_box(1) = 1;
    %             pos_img = pos_box+5;
    %         end
    %
    %         % drawing each bw-image of each method
    %         for idx_folder = 1:Results.num_experiments
    %             for idx_img = 1:EachImage.num_originalImage
    %                 image010 = repmat(imread(Results.experiments(idx_folder).bwImages(idx_img).path),1,1,3);
    %                 pos_img(2) = pos_box(2)+sizeBox(2)/2-sizeImage(idx_img,2)/2;
    %                 figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
    %                 pos_box(1) = pos_box(1)+sizeImage(idx_img,1)+10;
    %                 pos_img(1) = pos_box(1);
    %             end
    %             pos_box(2) = pos_box(2)+sizeBox(2);
    %             pos_box(1) = 1;
    %             pos_img = pos_box+5;
    %         end
    %
    %
    %
    %
    %     case '2'
    %         %% mode = '2' 表示每种方法的各个图像的二值图集中展示，每一列表示一组图像，每组图像有原图、真值图、各方法的二值图，是 mode = '1' 的转置
    %
    %         % 找出图像集的所有图像的纵横尺寸的最大值
    %         for i=1:EachImage.num_originalImage
    %             image010 = imread(EachImage.originalImage(i).path);
    %             [sizeImage(i,1) , sizeImage(i,2) , sizeImage(i,3)] = size(image010);
    %         end
    %         sizeImage=int16(sizeImage);
    %         clear image010;
    %
    %         maxSizeImage = max(sizeImage); % 每个子图（不含周边空白）的像素尺寸
    %         sizeBox = maxSizeImage+10; sizeBox(3)=[]; % 每个子图（含周边空白）的像素尺寸
    %         numBox = int16([Results.num_experiments + num_noExperimentsFolders, EachImage.num_originalImage]); % 子图个数 (横向 , 纵向)
    %
    %
    %         figure010 = repmat(0.85*ones(sizeBox.*numBox), 1,1,3); % 用二维数组描绘的超级大图 figure，灰色背景
    %
    %         pos_box = int16([1 1]); % 指向应该放置在 figure 的当前 box 的左上角位置，figure 的左上角为原点(1,1)
    %         pos_img = pos_box+5; % 指向应该放置在 figure 的当前 image 的左上角位置
    %
    %         % drawing each original image
    %         if (1==strcmp(Pros.isOriginalImages,'yes'))
    %             for idx_img = 1:EachImage.num_originalImage
    %                 image010 = double(imread(EachImage.originalImage(idx_img).path))/256;
    %                 pos_img(1) = pos_box(1)+sizeBox(1)/2-sizeImage(idx_img,1)/2;
    %                 figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
    %                 pos_box(2) = pos_box(2)+sizeImage(idx_img,2)+10;
    %                 pos_img(2) = pos_box(2);
    %             end
    %             pos_box(1) = pos_box(1)+sizeBox(1);
    %             pos_box(2) = 1;
    %             pos_img = pos_box+5;
    %         end
    %
    %         % drawing each scribbled image
    %         if (1==strcmp(Pros.isScribbledImages,'yes'))
    %             for idx_img = 1:EachImage.num_originalImage
    %                 image010 = double(imread(EachImage.scribbledImage(idx_img).path))/256;
    %                 pos_img(1) = pos_box(1)+sizeBox(1)/2-sizeImage(idx_img,1)/2;
    %                 figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
    %                 pos_box(2) = pos_box(2)+sizeImage(idx_img,2)+10;
    %                 pos_img(2) = pos_box(2);
    %             end
    %             pos_box(1) = pos_box(1)+sizeBox(1);
    %             pos_box(2) = 1;
    %             pos_img = pos_box+5;
    %         end
    %
    %         % drawing each gt-image
    %         if (1==strcmp(Pros.isGTImages,'yes'))
    %             for idx_img = 1:EachImage.num_originalImage
    %                 image010 = double(imread(EachImage.groundTruthBwImage(idx_img).path))/256;
    %                 pos_img(1) = pos_box(1)+sizeBox(1)/2-sizeImage(idx_img,1)/2;
    %                 figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
    %                 pos_box(2) = pos_box(2)+sizeImage(idx_img,2)+10;
    %                 pos_img(2) = pos_box(2);
    %             end
    %             pos_box(1) = pos_box(1)+sizeBox(1);
    %             pos_box(2) = 1;
    %             pos_img = pos_box+5;
    %         end
    %
    %         % drawing each bw-image of each method
    %         for idx_folder = 1:Results.num_experiments
    %             for idx_img = 1:EachImage.num_originalImage
    %                 image010 = repmat(imread(Results.experiments(idx_folder).bwImages(idx_img).path),1,1,3);
    %                 pos_img(1) = pos_box(1)+sizeBox(1)/2-sizeImage(idx_img,1)/2;
    %                 figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
    %                 pos_box(2) = pos_box(2)+sizeImage(idx_img,2)+10;
    %                 pos_img(2) = pos_box(2);
    %             end
    %             pos_box(1) = pos_box(1)+sizeBox(1);
    %             pos_box(2) = 1;
    %             pos_img = pos_box+5;
    %         end
    
    case '1'
        %% mode = '1' 表示每种方法的各个图像的二值图集中展示，每一行表示一组图像，每组图像有原图、真值图、各方法的二值图；
        numBox = int16([Pros.num_originalImage, Pros.num_experiments + num_noExperimentsFolders]); % 子图个数 (横向 , 纵向)
        direct1=1;
        direct2=2;
        
        
        
    case '2'
        %% mode = '2' 表示每种方法的各个图像的二值图集中展示，每一列表示一组图像，每组图像有原图、真值图、各方法的二值图，是 mode = '1' 的转置
        numBox = int16([ Pros.num_experiments + num_noExperimentsFolders ,Pros.num_originalImage]); % 子图个数 (横向 , 纵向)
        direct1=2;
        direct2=1;
        
        
    case '3'
        %% mode = '3' 表示每种方法的各个图像的二值图集中展示，每一行表示一组图像，每组图像排列内容自定义；
        numBox = int16([length(folder_images{Pros.foldersWhoIsOriginal}), length(folderpath_sub)]); % 子图个数 (横向 , 纵向)
        direct1=1;
        direct2=2;
        
        
    case '4'
        %% mode = '4' 表示每种方法的各个图像的二值图集中展示，每一列表示一组图像，每组图像排列内容自定义；
        
        numBox = int16([length(folderpath_sub) ,length(folder_images{Pros.foldersWhoIsOriginal})]); % 子图个数 (横向 , 纵向)
        direct1=2;
        direct2=1;
        
    case '5'
        %% TODO:
        
        
        
    otherwise
        error('error at choose mode !')
        
end

if (1==strcmp(Pros.mode,'1') || 1==strcmp(Pros.mode,'2'))
    
    figure010 = repmat(0.85*ones(sizeBox.*numBox), 1,1,3); % 用二维数组描绘的超级大图 figure，灰色背景
    
    pos_box = int16([1 1]); % 指向应该放置在 figure 的当前 box 的左上角位置，figure 的左上角为原点(1,1)
    pos_img = pos_box+5; % 指向应该放置在 figure 的当前 image 的左上角位置
    
    idx_noExperimentFolder = 0;
    
    % drawing each original image
    if (1==strcmp(Pros.isOriginalImages,'yes'))
        idx_noExperimentFolder = idx_noExperimentFolder +1;
        switch Pros.mode
            case '1'
                pos_box = int16([1 (idx_noExperimentFolder-1)*sizeBox(direct2)+1]);
            case '2'
                pos_box = int16([(idx_noExperimentFolder-1)*sizeBox(direct2)+1 1]);
        end
        pos_img = pos_box+5;
        for idx_img = 1:EachImage.num_originalImage
            image010 = double(imread(EachImage.originalImage(idx_img).path))/256;
            pos_img(direct2) = pos_box(direct2)+sizeBox(direct2)/2-sizeImage(idx_img,direct2)/2;
            figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
            pos_box(direct1) = pos_box(direct1)+sizeImage(idx_img,direct1)+10;
            pos_img(direct1) = pos_box(direct1);
        end
    end
    
    % drawing each scribbled image
    if (1==strcmp(Pros.isScribbledImages,'yes'))
        idx_noExperimentFolder = idx_noExperimentFolder +1;
        switch Pros.mode
            case '1'
                pos_box = int16([1 (idx_noExperimentFolder-1)*sizeBox(direct2)+1]);
            case '2'
                pos_box = int16([(idx_noExperimentFolder-1)*sizeBox(direct2)+1 1]);
        end
        pos_img = pos_box+5;
        for idx_img = 1:EachImage.num_originalImage
            image010 = double(imread(EachImage.scribbledImage(idx_img).path))/256;
            pos_img(direct2) = pos_box(direct2)+sizeBox(direct2)/2-sizeImage(idx_img,direct2)/2;
            figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
            pos_box(direct1) = pos_box(direct1)+sizeImage(idx_img,direct1)+10;
            pos_img(direct1) = pos_box(direct1);
        end
    end
    
    % drawing each GT-images
    if (1==strcmp(Pros.isGTImages,'yes'))
        idx_noExperimentFolder = idx_noExperimentFolder +1;
        switch Pros.mode
            case '1'
                pos_box = int16([1 (idx_noExperimentFolder-1)*sizeBox(direct2)+1]);
            case '2'
                pos_box = int16([(idx_noExperimentFolder-1)*sizeBox(direct2)+1 1]);
        end
        pos_img = pos_box+5;
        for idx_img = 1:EachImage.num_originalImage
            image010 = double(imread(EachImage.groundTruthBwImage(idx_img).path))/256;
            pos_img(direct2) = pos_box(direct2)+sizeBox(direct2)/2-sizeImage(idx_img,direct2)/2;
            figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
            pos_box(direct1) = pos_box(direct1)+sizeImage(idx_img,direct1)+10;
            pos_img(direct1) = pos_box(direct1);
        end
    end
    
    % drawing each bw-images
    for idx_folder = 1:Results.num_experiments
        switch Pros.mode
            case '1'
                pos_box = int16([1 (num_noExperimentsFolders + idx_folder -1)*sizeBox(direct2)+1]);
            case '2'
                pos_box = int16([(num_noExperimentsFolders + idx_folder -1)*sizeBox(direct2)+1 1]);
        end
        pos_img = pos_box+5;
        for idx_img=1:EachImage.num_originalImage
            image010 = repmat(imread(Results.experiments(idx_folder).bwImages(idx_img).path),1,1,3);
            pos_img(direct2) = pos_box(direct2)+sizeBox(direct2)/2-sizeImage(idx_img,direct2)/2;
            figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
            pos_box(direct1) = pos_box(direct1)+sizeImage(idx_img,direct1)+10;
            pos_img(direct1) = pos_box(direct1);
        end
    end
end

if (1==strcmp(Pros.mode,'3') || 1==strcmp(Pros.mode,'4'))
    figure010 = repmat(0.85*ones(sizeBox.*numBox), 1,1,3); % 用二维数组描绘的超级大图 figure，灰色背景
    
    pos_box = int16([1 1]); % 指向应该放置在 figure 的当前 box 的左上角位置，figure 的左上角为原点(1,1)
    pos_img = pos_box+5; % 指向应该放置在 figure 的当前 image 的左上角位置
    
    % drawing each original image
    if ~isempty(Pros.foldersWhoIsOriginal)
        switch Pros.mode
            case '3'
                pos_box = int16([1 (Pros.foldersWhoIsOriginal(1)-1)*sizeBox(direct2)+1]);
            case '4'
                pos_box = int16([(Pros.foldersWhoIsOriginal(1)-1)*sizeBox(direct2)+1 1]);
        end
        pos_img = pos_box+5;
        for idx_img = 1:length(folder_images{Pros.foldersWhoIsOriginal(1)})
            image010 = double(imread(fullfile(folder_images{Pros.foldersWhoIsOriginal}(idx_img).folder ,folder_images{Pros.foldersWhoIsOriginal}(idx_img).name)))/256;
            pos_img(direct2) = pos_box(direct2)+sizeBox(direct2)/2-sizeImage(idx_img,direct2)/2;
            figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
            pos_box(direct1) = pos_box(direct1)+sizeImage(idx_img,direct1)+10;
            pos_img(direct1) = pos_box(direct1);
        end
    end
    
    % drawing each scribbled image
    if ~isempty(Pros.foldersWhoIsScribbled)
        switch Pros.mode
            case '3'
                pos_box = int16([1 (Pros.foldersWhoIsScribbled(1)-1)*sizeBox(direct2)+1]);
            case '4'
                pos_box = int16([(Pros.foldersWhoIsScribbled(1)-1)*sizeBox(direct2)+1 1]);
        end
        pos_img = pos_box+5;
        for idx_img = 1:length(folder_images{Pros.foldersWhoIsScribbled})
            image010 = double(imread(fullfile(folder_images{Pros.foldersWhoIsScribbled}(idx_img).folder ,folder_images{Pros.foldersWhoIsScribbled}(idx_img).name)))/256;
            pos_img(direct2) = pos_box(direct2)+sizeBox(direct2)/2-sizeImage(idx_img,direct2)/2;
            figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
            pos_box(direct1) = pos_box(direct1)+sizeImage(idx_img,direct1)+10;
            pos_img(direct1) = pos_box(direct1);
        end
    end
    
    % drawing each GT-images
    if ~isempty(Pros.foldersWhoIsGtImage)
        switch Pros.mode
            case '3'
                pos_box = int16([1 (Pros.foldersWhoIsGtImage(1)-1)*sizeBox(direct2)+1]);
            case '4'
                pos_box = int16([(Pros.foldersWhoIsGtImage(1)-1)*sizeBox(direct2)+1 1]);
        end
        pos_img = pos_box+5;
        for idx_img=1:length(folder_images{Pros.foldersWhoIsGtImage})
            image010 = double(imread(fullfile(folder_images{Pros.foldersWhoIsGtImage}(idx_img).folder ,folder_images{Pros.foldersWhoIsGtImage}(idx_img).name)))/256;
            pos_img(direct2) = pos_box(direct2)+sizeBox(direct2)/2-sizeImage(idx_img,direct2)/2;
            figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
            pos_box(direct1) = pos_box(direct1)+sizeImage(idx_img,direct1)+10;
            pos_img(direct1) = pos_box(direct1);
        end
    end
    
    % drawing each bw-images
    if ~isempty(Pros.foldersWhoIsBwImage)
        for idx_folder=Pros.foldersWhoIsBwImage
            switch Pros.mode
                case '3'
                    pos_box = int16([1 (idx_folder-1)*sizeBox(direct2)+1]);
                case '4'
                    pos_box = int16([(idx_folder-1)*sizeBox(direct2)+1 1]);
            end
            pos_img = pos_box+5;
            for idx_img=1:length(folder_images{idx_folder})
                image010 = imread(fullfile(folder_images{idx_folder}(idx_img).folder ,folder_images{idx_folder}(idx_img).name));
                pos_img(direct2) = pos_box(direct2)+sizeBox(direct2)/2-sizeImage(idx_img,direct2)/2;
                figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
                pos_box(direct1) = pos_box(direct1)+sizeImage(idx_img,direct1)+10;
                pos_img(direct1) = pos_box(direct1);
            end
        end
    end
    
    % drawing each images that need colormaping
    if ~isempty(Pros.foldersWhoNeedColormap)
        for idx_folder=Pros.foldersWhoNeedColormap
            switch Pros.mode
                case '3'
                    pos_box = int16([1 (idx_folder-1)*sizeBox(direct2)+1]);
                case '4'
                    pos_box = int16([(idx_folder-1)*sizeBox(direct2)+1 1]);
            end
            pos_img = pos_box+5;
            for idx_img = 1:length(folder_images{idx_folder})
                image010 = imread(fullfile(folder_images{idx_folder}(idx_img).folder ,folder_images{idx_folder}(idx_img).name)); % uint8
                [numRow,numCol,numChannal]=size(image010);
                
                if numChannal==1
                    colormap010=colormap(parula(256));
                    image020=double(zeros(numRow,numCol,3));
                    for i=1:1:256
                        [row,col,value]=find(image010==i-1);
                        if ~isempty(row)
                            for j=1:length(row)
                                image020(row(j),col(j),:)=colormap010(i,:);
                            end
                        end
                    end
                else
                    image020=double(image010)/256;
                end
                
                pos_img(direct2) = pos_box(direct2)+sizeBox(direct2)/2-sizeImage(idx_img,direct2)/2;
                figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image020;
                pos_box(direct1) = pos_box(direct1)+sizeImage(idx_img,direct1)+10;
                pos_img(direct1) = pos_box(direct1);
            end
        end
    end
end

% show
figure010 = uint8(256*figure010);
% imtool(figure010);


% save
filename_figure = ['论文展示大图.bmp'];
filepath_figure = fullfile(Pros.folderpath_experiment, filename_figure);
imwrite(figure010, filepath_figure);


% %% mode = '4' 表示每种方法的各个图像的二值图集中展示，每一列表示一组图像，每组图像排列内容自定义；
%
% folderpath_sub=dir(Pros.folderpath_customeInput);
% folderpath_sub(1:2)=[];
% for i =1:length(folderpath_sub)
%     folder_images{i}=dir([fullfile(folderpath_sub(i).folder,folderpath_sub(i).name) '\*']);
%     folder_images{i}(1:2)=[];
% end
%
% % 找出图像集的所有图像的纵横尺寸的最大值
% for idx_img=1:length(folder_images{Pros.foldersWhoIsOriginal(1)})
%     image010 = imread(fullfile(folder_images{Pros.foldersWhoIsOriginal(1)}(idx_img).folder ,folder_images{Pros.foldersWhoIsOriginal(1)}(idx_img).name));
%     [sizeImage(idx_img,1) , sizeImage(idx_img,2) , sizeImage(idx_img,3)] = size(image010);
% end
% sizeImage=int16(sizeImage);
% clear image010;
%
% maxSizeImage = max(sizeImage); % 每个子图（不含周边空白）的像素尺寸
% sizeBox = maxSizeImage+10; sizeBox(3)=[]; % 每个子图（含周边空白）的像素尺寸
% numBox = int16([length(folderpath_sub) ,length(folder_images{Pros.foldersWhoIsOriginal})]); % 子图个数 (横向 , 纵向)
%
% figure010 = repmat(0.85*ones(sizeBox.*numBox), 1,1,3); % 用二维数组描绘的超级大图 figure，灰色背景
%
% pos_box = int16([1 1]); % 指向应该放置在 figure 的当前 box 的左上角位置，figure 的左上角为原点(1,1)
% pos_img = pos_box+5; % 指向应该放置在 figure 的当前 image 的左上角位置
%
% % drawing each original image
% if ~isempty(Pros.foldersWhoIsOriginal)
%     pos_box = int16([(Pros.foldersWhoIsOriginal(1)-1)*sizeBox(1)+1 1]);
%     pos_img = pos_box+5;
%     for idx_img = 1:length(folder_images{Pros.foldersWhoIsOriginal(1)})
%         image010 = double(imread(fullfile(folder_images{Pros.foldersWhoIsOriginal}(idx_img).folder ,folder_images{Pros.foldersWhoIsOriginal}(idx_img).name)))/256;
%         pos_img(1) = pos_box(1)+sizeBox(1)/2-sizeImage(idx_img,1)/2;
%         figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
%         pos_box(2) = pos_box(2)+sizeImage(idx_img,2)+10;
%         pos_img(2) = pos_box(2);
%     end
% end
%
% % drawing each scribbled image
% if ~isempty(Pros.foldersWhoIsScribbled)
%     pos_box = int16([(Pros.foldersWhoIsScribbled(1)-1)*sizeBox(1)+1 1]);
%     pos_img = pos_box+5;
%     for idx_img = 1:length(folder_images{Pros.foldersWhoIsScribbled}(2))
%         image010 = double(imread(fullfile(folder_images{Pros.foldersWhoIsScribbled}(idx_img).folder ,folder_images{Pros.foldersWhoIsScribbled}(idx_img).name)))/256;
%         pos_img(1) = pos_box(1)+sizeBox(1)/2-sizeImage(idx_img,1)/2;
%         figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
%         pos_box(2) = pos_box(2)+sizeImage(idx_img,2)+10;
%         pos_img(2) = pos_box(2);
%     end
% end
%
% % drawing each GT-images
% if ~isempty(Pros.foldersWhoIsGtImage)
%     pos_box = int16([(Pros.foldersWhoIsGtImage(1)-1)*sizeBox(1)+1 1]);
%     pos_img = pos_box+5;
%     for idx_img=1:length(folder_images{Pros.foldersWhoIsGtImage})
%         image010 = double(imread(fullfile(folder_images{Pros.foldersWhoIsGtImage}(idx_img).folder ,folder_images{Pros.foldersWhoIsGtImage}(idx_img).name)))/256;
%         pos_img(1) = pos_box(1)+sizeBox(1)/2-sizeImage(idx_img,1)/2;
%         figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
%         pos_box(2) = pos_box(2)+sizeImage(idx_img,2)+10;
%         pos_img(2) = pos_box(2);
%     end
% end
%
% % drawing each bw-images
% if ~isempty(Pros.foldersWhoIsBwImage)
%     for idx_folder=Pros.foldersWhoIsBwImage
%         pos_box = int16([(idx_folder-1)*sizeBox(1)+1 1]);
%         pos_img = pos_box+5;
%         for idx_img=1:length(folder_images{idx_folder})
%             image010 = imread(fullfile(folder_images{idx_folder}(idx_img).folder ,folder_images{idx_folder}(idx_img).name));
%             pos_img(1) = pos_box(1)+sizeBox(1)/2-sizeImage(idx_img,1)/2;
%             figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image010;
%             pos_box(2) = pos_box(2)+sizeImage(idx_img,2)+10;
%             pos_img(2) = pos_box(2);
%         end
%     end
% end
%
% % drawing each images that need colormaping
% if ~isempty(Pros.foldersWhoNeedColormap)
%     for idx_folder=Pros.foldersWhoNeedColormap
%         pos_box = int16([(idx_folder-1)*sizeBox(1)+1 1]);
%         pos_img = pos_box+5;
%         for idx_img = 1:length(folder_images{idx_folder})
%             image010 = imread(fullfile(folder_images{idx_folder}(idx_img).folder ,folder_images{idx_folder}(idx_img).name)); % uint8
%             [numRow,numCol,numChannal]=size(image010);
%
%             if numChannal==1
%                 colormap010=colormap(parula(256));
%                 image020=double(zeros(numRow,numCol,3));
%                 for i=1:1:256
%                     [row,col,value]=find(image010==i-1);
%                     if ~isempty(row)
%                         for j=1:length(row)
%                             image020(row(j),col(j),:)=colormap010(i,:);
%                         end
%                     end
%                 end
%             else
%                 image020=double(image010)/256;
%             end
%
%             pos_img(1) = pos_box(1)+sizeBox(1)/2-sizeImage(idx_img,1)/2;
%             figure010(pos_img(1):pos_img(1)+sizeImage(idx_img,1)-1, pos_img(2):pos_img(2)+sizeImage(idx_img,2)-1, :) = image020;
%             pos_box(2) = pos_box(2)+sizeImage(idx_img,2)+10;
%             pos_img(2) = pos_box(2);
%         end
%     end
% end
%
%
% % show
% figure010 = uint8(256*figure010);
% imtool(figure010);
%
% % save
% filename_figure = ['论文展示大图.bmp'];
% filepath_figure = fullfile(Pros.folderpath_experiment, filename_figure);
% imwrite(figure010, filepath_figure);
%
%
%










%%
diary off;
toc;
text=['程序运行完毕。'];
disp(text)
sp.Speak(text);
