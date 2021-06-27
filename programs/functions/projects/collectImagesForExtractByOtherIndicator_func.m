function []=collectImagesForExtractByOtherIndicator_func(Args)
%% 简介
% collectImagesForExtractByOtherIndicator.m 实现提取各个方法的图像以及真值图到指定文件夹以便于人工筛选
% 提取指定的文件和文件夹的模式有如下三种：
% 模式1 表示在带有较强的评价指标的限制条件下的第一轮筛选下，提取相应图像。
% 模式2 表示在带有较弱的评价指标的限制条件下的第一轮筛选下，提取相应图像。
% 模式3 表示无筛选的情况下，提取相应图像。
% 注意程序运行时会提示要求输入实验组！


diary off;


% %% 用户输入初始参数 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Args.mode = '3' ; % 提取指定的文件和文件夹的模式，如简介所述。
% Args.folderpath_reourcesDatasets = '.\candidate\resources';    % 基础资源文件（原图、真值图、标记图）的基本路径
% Args.folderpath_initDatasets = '.\candidate\init resources';    % 基础初始化文件（各种初始化方法生成的如初始轮廓二值图、各参数、时间参数等）的基本路径
% Args.folderpath_ResultsBaseFolder = '.\data\ACMGMMSEMI\MSRA1K\evaluation'; % 用于提取文件的结构体 Results 的基本路径。
% % Args.folderpath_finalResultsBaseFolder = '.\data\evaluation\circleACMGMM 5-28挑出来\要做kmeans+AMCGMM聚类的\end0.001'; % 用于提取文件的结构体 Results 的基本路径。
% Args.folderpath_outputBase = '.\data\ACMGMMSEMI\MSRA1K\extract'; % 提取文件的目标文件夹
% 
% Args.outputMode = 'datatime' ;	 % 指定存放这次实验的文件夹的文件名称显示类型。可选 'datatime' 'index'。'datatime' 表示实验文件夹名称是日期时间；'index'表示实验文件夹名称是编号。默认 'datatime'。推荐用默认值。
% Args.num_scribble = 1; % 所有待处理的图像的标记总数。由于目前暂时不考虑不同标记对分割效果的影响，而仅仅用一张图像一种标记，因此目前手动设置为1。
% Args.isVisual = 'no' ;  % 绘制过程不可视化，程序结束后自行查看结果。 'yes'表示绘制过程中可视化 ，'no'表示绘制过程中不可视化。默认'no'
% Args.numUselessFiles = 0; % 要排除的图像数量。有时候存储图片的文件夹除了有图像文件，还有可能是系统文件会被误处理，因此需要手动排除。
% Args.ratioOfGood = 0.85 ; % 定义好的图像的所占的指标的值的比例阈值。值域[0,1]，默认 0.85
% Args.ratioOfBad = 0.5 ; % 定义差的图像的所占的指标的值的比例阈值。值域[0,1]，默认 0.65
% Args.ratioOfBetter = 0.001 ; % 两种方法比较时，方法A要比方法B的指标的值的比例要大于等于该值，才认为明显好。值域[0,1]，默认 0.3
% Args.ratioOfBetterAtBothGood = 0.001 ; % 两种方法比较时，两种方法都好的情况下，方法A要比方法B的指标的值的比例要大于等于该值，才认为明显好。值域[0,1]，默认0.1
% Args.ratioOfRegion = 1.0; % 实验组和对照组比较时，实验组效果比对照组效果不好的图像数量 占 实验组效果比对照组效果好的图像数量 的比例。
% Args.ratioOfRand = 0.1; % 控制实验组和对照组比较时，实验组效果好的图像数量占总图像数量的比例的随机范围。
% Args.numImagesShow = 1000 ; % 要提取的图像的最大限制数量。
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% properties
Pros = Args

%% 构建文件夹的资源resources 结构体EachImage，构建results文件夹里指定做的指标的文件路径和名称的结构体 Results
EachImage = createEachImageStructure(Pros.folderpath_reourcesDatasets ,Pros.folderpath_initDatasets, Pros.numUselessFiles);
Results = createResultsStructure(Pros.folderpath_ResultsBaseFolder ,Pros.numUselessFiles);
% Results_final = createResultsStructure(Pros.folderpath_finalResultsBaseFolder, Pros.numUselessFiles);

% Pros.indexOfScribbledImageFolder = findIndexOfFolderName(EachImage, 'scribbled images');
% Pros.indexOfOriginalImageFolder = findIndexOfFolderName(EachImage, 'original images');
% Pros.indexOfBwDataFolder = findIndexOfFolderName(EachImage, 'bw data');
% Pros.indexOfBwImagesFolder = findIndexOfFolderName(EachImage, 'bw images');
% Pros.indexOfGTFolder = findIndexOfFolderName(EachImage, 'ground truth images');
% Pros.indexOfEvaluationsFolder = findIndexOfFolderName(EachImage, 'evaluations');
% Pros.indexOfFiguresFolder = findIndexOfFolderName(EachImage, 'figures');
%

%% 设置实验组：
Args.experiment = input('确认文件夹里的文件数量是否正确？正确的话输入编号指定实验组，并继续，否则按 Ctrl+c 终止程序。')

%% 构建文件夹
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
% 要处理的图像数量。有时候存储图片的文件夹除了有图像文件，还有可能是系统文件会被误处理，因此需要手动排除
Pros.num_image = EachImage.num_groundTruthBwImage;
Pros.num_experiments = Results.num_experiments;

%% 记录日志
% 生成diary输出文件夹
Pros.filename_diary = 'diary evaluation analyse.txt';
Pros.filepath_diary = fullfile(Pros.folderpath_experiment, Pros.filename_diary);
diary(Pros.filepath_diary);
diary on;
Args

%% 计时
tic;

switch Pros.mode
    case '1'
        
        %% 打印
        disp(['定义好的图像的所占的指标的值的比例阈值：' num2str(Pros.ratioOfGood)])
        disp(['定义差的图像的所占的指标的值的比例阈值：' num2str(Pros.ratioOfBad)])
        disp(['两种方法比较时，方法A要比方法B的指标的值的比例要大于等于该值，才认为明显好。该值设置为：' num2str(Pros.ratioOfBetter)])
        disp(['两种方法比较时，两种方法都好的情况下，方法A要比方法B的指标的值的比例要大于等于该值，才认为明显好。该值设置为：' num2str(Pros.ratioOfBetterAtBothGood)])
        disp(['实验组和对照组比较时，实验组效果好的图像数量占总图像数量的比例。该值设置为：' num2str(Pros.ratioOfRegion)])
        disp(['控制实验组和对照组比较时，实验组效果好的图像数量占总图像数量的比例的随机范围。该值设置为：' num2str(Pros.ratioOfRand)])
        
        %%
        JD=zeros(Pros.num_image,Pros.num_experiments);
        for i=1:Pros.num_experiments
            % 			filenameStr = '_Jaccard_compareTwo' ;
            load(fullfile(Results.experiments(i).folderpath_evaluationData, 'jaccardDistance.mat'));
            JD(:,i)=jaccardDistance;
            clear jaccardDistance;
        end
        labelStr_JD= 'Jaccard Distance';
        ceilValue_JD = 1; % 指标的值能达到的最大值设定。下同。
        isReverseAxes_JD = 'yes'; % 如果指标是越小越好，则需要反转。下同。
        
        MHD=zeros(Pros.num_image,Pros.num_experiments);
        for i=1:Pros.num_experiments
            % 			filenameStr = '_Jaccard_compareTwo' ;
            load(fullfile(Results.experiments(i).folderpath_evaluationData, 'modifiedHausdorffDistance.mat'));
            MHD(:,i)=modifiedHausdorffDistance;
            clear modifiedHausdorffDistance;
        end
        labelStr_MHD = 'Modified Hausdorff Distance';
        ceilValue_MHD = max(MHD(:));
        isReverseAxes_MHD = 'yes';
        
        F1indicator=zeros(Pros.num_image,Pros.num_experiments);
        for i=1:Pros.num_experiments
            % 			filenameStr = '_Jaccard_compareTwo' ;
            load(fullfile(Results.experiments(i).folderpath_evaluationData, 'F1.mat'));
            F1indicator(:,i)=F1;
            clear F1;
        end
        labelStr_F1 = 'F1';
        ceilValue_F1 = 1;
        isReverseAxes_F1 = 'no';
        
        
        %% 统计对比两种方法在各自指标下，图像数量的属性
        % 在JD指标下，各种方法处理效果不差，且实验组比两个对照组的效果都好一些的图像
        imagesBothNotBadAnd1better_JD(:,1)=find((JD(:,1)<=(1-Pros.ratioOfBad)*ceilValue_JD) & (JD(:,2)<=(1-Pros.ratioOfBad)*ceilValue_JD) & (JD(:,3)<=(1-Pros.ratioOfBad)*ceilValue_JD) & (JD(:,1)-JD(:,2)>Pros.ratioOfBetter) & (JD(:,1)-JD(:,3)>Pros.ratioOfBetter));
        for i=1:Pros.num_experiments
            imagesBothNotBadAnd1better_JD(:,i+1) = JD(imagesBothNotBadAnd1better_JD(:,1),i);
        end
        num_imagesBothNotBadAnd1better_JD=size(imagesBothNotBadAnd1better_JD,1);
        
        % 在MHD指标下，各种方法处理效果不差，且实验组比两个对照组的效果都好一些的图像
        imagesBothNotBadAnd1better_MHD(:,1) = find((MHD(:,1)<=(1-Pros.ratioOfBad)*ceilValue_MHD) & (MHD(:,2)<=(1-Pros.ratioOfBad)*ceilValue_MHD) & (MHD(:,3)<=(1-Pros.ratioOfBad)*ceilValue_MHD) & (MHD(:,1)-MHD(:,2)>Pros.ratioOfBetter) & (MHD(:,1)-MHD(:,3)>Pros.ratioOfBetter));
        for i=1:Pros.num_experiments
            imagesBothNotBadAnd1better_MHD(:,i+1) = MHD(imagesBothNotBadAnd1better_MHD(:,1),i);
        end
        num_imagesBothNotBadAnd1better_MHD=size(imagesBothNotBadAnd1better_MHD,1);
        
        % 在F1指标下，各种方法处理效果不差，且实验组比两个对照组的效果都好一些的图像
        imagesBothNotBadAnd1better_F1(:,1) = find((F1indicator(:,1)>=Pros.ratioOfBad*ceilValue_F1) & (F1indicator(:,2)>=Pros.ratioOfBad*ceilValue_F1) & (F1indicator(:,3)>=Pros.ratioOfBad*ceilValue_F1) & (F1indicator(:,1)-F1indicator(:,2)>Pros.ratioOfBetter) & (F1indicator(:,1)-F1indicator(:,3)>Pros.ratioOfBetter));
        for i=1:Pros.num_experiments
            imagesBothNotBadAnd1better_F1(:,i+1) = F1indicator(imagesBothNotBadAnd1better_F1(:,1),i);
        end
        num_imagesBothNotBadAnd1better_F1=size(imagesBothNotBadAnd1better_F1,1);
        
        
        % 在JD指标下，各种方法处理效果不差，且实验组比两个对照组的效果差一些的图像
        imagesBothNotBadAnd1worse_JD(:,1)=find((JD(:,1)<=(1-Pros.ratioOfBad)*ceilValue_JD) & (JD(:,2)<=(1-Pros.ratioOfBad)*ceilValue_JD) & (JD(:,3)<=(1-Pros.ratioOfBad)*ceilValue_JD) & ((JD(:,2)-JD(:,1)>Pros.ratioOfBetter) | (JD(:,3)-JD(:,1)>Pros.ratioOfBetter)));
        for i=1:Pros.num_experiments
            imagesBothNotBadAnd1worse_JD(:,i+1) = JD(imagesBothNotBadAnd1worse_JD(:,1),i);
        end
        num_imagesBothNotBadAnd1worse_JD=size(imagesBothNotBadAnd1worse_JD,1);
        
        % 在MHD指标下，各种方法处理效果不差，且实验组比两个对照组的效果差一些的图像
        imagesBothNotBadAnd1worse_MHD(:,1) = find((MHD(:,1)<=(1-Pros.ratioOfBad)*ceilValue_MHD) & (MHD(:,2)<=(1-Pros.ratioOfBad)*ceilValue_MHD) & (MHD(:,3)<=(1-Pros.ratioOfBad)*ceilValue_MHD) & ((MHD(:,2)-MHD(:,1)>Pros.ratioOfBetter) | (MHD(:,3)-MHD(:,1)>Pros.ratioOfBetter)));
        for i=1:Pros.num_experiments
            imagesBothNotBadAnd1worse_MHD(:,i+1) = MHD(imagesBothNotBadAnd1worse_MHD(:,1),i);
        end
        num_imagesBothNotBadAnd1worse_MHD=size(imagesBothNotBadAnd1worse_MHD,1);
        
        % 在F1指标下，各种方法处理效果不差，且实验组比两个对照组的效果差一些的图像
        imagesBothNotBadAnd1worse_F1(:,1) = find((F1indicator(:,1)>=Pros.ratioOfBad*ceilValue_F1) & (F1indicator(:,2)>=Pros.ratioOfBad*ceilValue_F1) & (F1indicator(:,3)>=Pros.ratioOfBad*ceilValue_F1) & ((F1indicator(:,2)-F1indicator(:,1)>Pros.ratioOfBetter) | (F1indicator(:,3)-F1indicator(:,1)>Pros.ratioOfBetter)));
        for i=1:Pros.num_experiments
            imagesBothNotBadAnd1worse_F1(:,i+1) = F1indicator(imagesBothNotBadAnd1worse_F1(:,1),i);
        end
        num_imagesBothNotBadAnd1worse_F1=size(imagesBothNotBadAnd1worse_F1,1);
        
        
        %% 提取相关图像
        % 预提取相关图像
        images_JD=union(imagesBothNotBadAnd1better_JD(:,1),imagesBothNotBadAnd1worse_JD(1:num_imagesBothNotBadAnd1better_JD*Pros.ratioOfRegion,1));
        images_MHD=union(imagesBothNotBadAnd1better_MHD(:,1),imagesBothNotBadAnd1worse_MHD(1:num_imagesBothNotBadAnd1better_MHD*Pros.ratioOfRegion,1));
        images_F1=union(imagesBothNotBadAnd1better_F1(:,1),imagesBothNotBadAnd1worse_F1(1:num_imagesBothNotBadAnd1better_F1*Pros.ratioOfRegion,1));
        temp010=union(images_JD,images_MHD);
        imagesNeed=union(temp010,images_F1);
        numImageRatio = Pros.numImagesShow/size(imagesNeed,1);  % 获得我们大致需要的图像数占总数的比例
        images_JD=[];
        images_MHD=[];
        images_F1=[];
        temp010=[];
        imagesNeed=[];
        % 正式提取相关图像，由于是随机提取，所以每次都可能不一样
        randInterger1 = randperm(size(imagesBothNotBadAnd1better_JD,1),ceil(numImageRatio*num_imagesBothNotBadAnd1better_JD));
        temp005=imagesBothNotBadAnd1better_JD(randInterger1,1);
        randInterger2 = randperm(size(imagesBothNotBadAnd1worse_JD,1),ceil(numImageRatio*num_imagesBothNotBadAnd1better_JD*Pros.ratioOfRegion));
        temp006=imagesBothNotBadAnd1worse_JD(randInterger2,1);
        images_JD=union(temp005,temp006);
        randInterger3 = randperm(size(imagesBothNotBadAnd1better_MHD,1),ceil(numImageRatio*num_imagesBothNotBadAnd1better_MHD));
        temp005=imagesBothNotBadAnd1better_MHD(randInterger3,1);
        randInterger4 = randperm(size(imagesBothNotBadAnd1worse_MHD,1),ceil(numImageRatio*num_imagesBothNotBadAnd1better_MHD*Pros.ratioOfRegion));
        temp006=imagesBothNotBadAnd1worse_MHD(randInterger4,1);
        images_MHD=union(temp005,temp006);
        temp007=imagesBothNotBadAnd1better_F1(randInterger3,1);
        randInterger4 = randperm(size(imagesBothNotBadAnd1worse_F1,1),ceil(numImageRatio*num_imagesBothNotBadAnd1better_F1*Pros.ratioOfRegion));
        temp008=imagesBothNotBadAnd1worse_F1(randInterger4,1);
        images_F1=union(temp007,temp008);
        temp010=union(images_JD,images_MHD);
        imagesNeed=union(temp010,images_F1);
        num_imagesNeeded = size(imagesNeed,1);
        
        %% collect 收集需要的图像到指定的文件夹
        folderpath_images = Pros.folderpath_experiment;
        if ~exist(folderpath_images,'dir')
            mkdir(folderpath_images);
        end
        for i=1:num_imagesNeeded
            copyfile(EachImage.originalImage(imagesNeed(i)).path, folderpath_images);
            copyfile(EachImage.groundTruthBwImage(imagesNeed(i)).path, folderpath_images);
            copyfile(EachImage.contourImage(imagesNeed(i)).path, folderpath_images);
            copyfile(EachImage.scribbledImage(imagesNeed(i)).path, folderpath_images);
        end
        
        
    case '2'
        %% TODO
        
    case '3'
        %% 提取相关图像
        % 提取相关图像并重命名文件名以方便用户筛选
        
        folderpath_images = Pros.folderpath_experiment;
        if ~exist(folderpath_images,'dir')
            mkdir(folderpath_images);
        end
        
        for index_experiment = 1:Pros.num_experiments
            load(fullfile(Results.experiments(index_experiment).folderpath_evaluationData, 'time.mat'));
        end
        
        for index_image=1:Pros.num_image
            % extracting original image
            copyfile(EachImage.originalImage(index_image).path, fullfile(folderpath_images, EachImage.originalImage(index_image).name));
            % extracting initalized contour
            filename_newImg = [EachImage.originalImage(index_image).name(1:end-4) '_init.bmp'];
            copyfile(EachImage.contourImage(index_image).path, fullfile(folderpath_images, filename_newImg));
            % extracting ground truth image
            filename_newImg = [EachImage.originalImage(index_image).name(1:end-4) '_gt.bmp'];
            copyfile(EachImage.groundTruthBwImage(index_image).path, fullfile(folderpath_images, filename_newImg));
            % 如果需要中间结果的话，可以启用这段代码【
            % 			for index_experiment = 1:Pros.num_experiments
            % 							filename_newImg = [EachImage.originalImage(index_image).name(1:end-4) '_' Results_final.experiments(index_experiment).name '.bmp'];
            % 				copyfile(Results_final.experiments(index_experiment).bwImages(index_image).path, fullfile(folderpath_images, filename_newImg));
            % 			end
            % 】
        end
        
        % extracting bw-image of each methods
        for index_experiment = 1:Pros.num_experiments
            load(fullfile(Results.experiments(index_experiment).folderpath_evaluationData, 'time.mat'));
            for index_image=1:Pros.num_image
                filename_newImg = [EachImage.originalImage(index_image).name(1:end-4) '_' Results.experiments(index_experiment).name '_iter' num2str(elipsedEachTime.iteration(index_image)) '_time' num2str(elipsedEachTime.time(index_image)) '.bmp'];
                copyfile(Results.experiments(index_experiment).bwImages(index_image).path, fullfile(folderpath_images, filename_newImg));
            end
        end
        
        
        
    otherwise
        error('error at choose mode');
end


%%
diary off;
toc;
text=['程序运行完毕。'];
disp(text)
sp.Speak(text);

end
