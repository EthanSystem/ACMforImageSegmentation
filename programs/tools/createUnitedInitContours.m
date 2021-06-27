%% 简介
% createUnitedInitContours.m 对于每一张图像，生成统一的初始轮廓。该初始轮廓和基于ACMandGMM算法生成的初始轮廓一致。
clear all;
close all;
clc;
diary off;
sp=actxserver('SAPI.SpVoice');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 选择初始化方式。
...可选：
    ...'scribbled_kmeans'  %% 使用用户划线方式生成的有标记数据 + EM-GMM 方法生成的
    ...'scribbled_circle'   %% 使用 scribbled 生成 GMM 初始参数，用 circle 生成初始轮廓
    ...'circle'    %% 使用 circle 初始化方法
    ...'kmeans'     %% 使用 k-means 初始化方式
    ...'circle_kmeans'    %% 使用 circle 作为初始轮廓，k-means 作为初始参数
    ...'kmeans_ACMGMM'    %% 借鉴[1] Guowei Gao等人的方法，用k-means初始化，以计算水平集演化
    ...'circle_ACMGMM'    %% 借鉴[1] Guowei Gao等人的方法，计算水平集演化，用于生成初始轮廓
    
Args.initMethod = 'circle_SDF_ACMGMM' ;


Args.maxIterOfKmeans = 100 ; % 用 kmeans 初始化的时候的最大迭代次数。

Args.folderpath_reourcesDatasets ='.\data\resources\MSRA1K\original resources' ;	% 基础资源文件（原图、真值图、标记图）的基本路径
% % 基础初始化文件（各种初始化方法生成的如初始轮廓二值图、各参数、时间参数等）的基本路径， 也是存放生成结果的文件夹。
Args.folderpath_initDatasets ='.\data\resources\MSRA1K\init resources';
Args.folderpath_initResources =fullfile(Args.folderpath_initDatasets, [Args.initMethod]);	
% Args.folderpath_initResources =['.\candidate\init resources\circle_staircase'];

Args.timestep=0.10;  % time step
Args.epsilon = 0.50 ; % papramater that specifies the width of the DiracDelta function. default=0.5 and more at [1].
Args.mu = 1.0;  % coefficeient of the weighted probability term prob(phi).
Args.beta=0.5; % coefficeient of the weighted length term L(phi). default=0.5.
Args.gamma=0.00;  % coefficient of the weighted area term A(phi). default=0.2.
Args.sigma=1.5;     % scale parameter in Gaussian kernel , default is 1.5 .
Args.hsize=5 ;			% 高斯滤波器的模板大小，default is 15, also means 15 x 15.
Args.circleRadius = 100; % radius of the circle for initializing contour.
Args.numUselessFiles = 0;   % 有时候存储图片的文件夹除了有图像文件，还有可能是系统文件会被误处理，因此需要手动排除无用文件的数量。但是此功能有bug。
Args.numOfComponents = 2; % 概率项的分枝数
Args.contoursInitValue = 1; % 初始水平集函数的值
Args.smallNumber=realmin+1E-20;  % 允许添加的防止除法运算误差最小数。

% 以下不能改
% Args.isNotVisiualEvolutionAtAll = 'yes' ; % 程序运行过程中是否完全不可视化中间过程和保存中间过程图 。默认'yes'
% Args.isNotWriteDataAtAll = 'yes' ; % 程序运行过程中产生的结果数据是否保存，如果是，那么就不保存结果数据，但是最终的二值图图像还是会保存的。默认 'yes'
% Args.numIteration_inner=1; % 内循环次数，default = 1
% Args.iteration_inner=1; % 内循环初始值，default = 1
% Args.numIteration_outer=1; % 外循环次数，default = 1000
% Args.iteration_outer=1; % 外循环初始值，default = 1

Pros=Args


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

EachImage = createEachImageStructure(Pros.folderpath_reourcesDatasets, Pros.folderpath_initResources, Pros.numUselessFiles);

input('确认文件夹里的文件数量是否正确？正确按任意键继续，否则按 Ctrl+c 终止程序。')
% indexOfScribbledImageFolder = findIndexOfFolderName(EachImage, 'scribbled images');
% indexOfOriginalImageFolder = findIndexOfFolderName(EachImage, 'original images');
% indexOfBwImageFolder = findIndexOfFolderName(EachImage, 'bw images');
% indexOfGTFolder = findIndexOfFolderName(EachImage, 'ground truth bw images');
% indexOfEvaluationsFolder = findIndexOfFolderName(EachImage, 'evaluations');

if ~exist(Pros.folderpath_initResources,'dir')
    mkdir(Pros.folderpath_initResources)
end

%% 开启 diary 记录
Pros.folderpath_diary = Pros.folderpath_initResources;
Pros.filepath_diary = fullfile(Pros.folderpath_diary , [ '统一的初始轮廓的相关参数.txt']);
diary(Pros.filepath_diary);
diary on;
Args % 打印 Args

%%
numState = Pros.numOfComponents;
numImage = EachImage.num_originalImage;
for index_image=1:numImage
    %%
    filepath_original = EachImage.originalImage(index_image).path;
    image_original = imread(filepath_original);
    image_processed = image_original;
    Pros.sizeOfImage=[size(image_original)];
    Pros.numData = Pros.sizeOfImage(1).*Pros.sizeOfImage(2);
    [numRow, numCol, numVar] = deal(Pros.sizeOfImage(1),Pros.sizeOfImage(2),Pros.sizeOfImage(3));
    numPixels =numRow * numCol;
    image_data = double(image_original);
    data = reshape(image_data ,[],numVar); % 要处理的图像数据。像素数×维数
    data=data.'; % 要处理的图像数据。维数×像素数
    Pxi = zeros( numPixels,numState); % Pxi：条件概率。图像像素数×分类数
    
    %% 生成初始轮廓
    switch Pros.initMethod
        case 'scribbled_kmeans_1'
            %% scribbled_kmeans_1：第一种：使用用户划线方式生成的有标记数据 + kmeans 方法生成 GMM 参数、初始轮廓。
            
            % 初始轮廓的值类型
            Args0.initializeType = 'staircase';
            
            % 开始计时
            Pros.elipsedEachTime=0;
            tic;
            
            
            
            load(EachImage.seedsIndex1(index_image).path);
            load(EachImage.seedsIndex2(index_image).path);
            data_foreground=zeros(3,size(seedsIndex1,1));
            data_foreground=data(:,seedsIndex1(:));
            data_background=zeros(3,size(seedsIndex2,1));
            data_background=data(:,seedsIndex2(:));
            
            [Prior0, mu0,Sigma0 ]= EM_init_kmeans([data_foreground data_background], 2, Pros.maxIterOfKmeans); % Pi：先验概率。1×分类数；均值：维数×分枝数；协方差：维数×维数×分类数
            
            % create phi0
            for i=1:numState
                %Compute probability p(x|i)
                Pxi(:,i) = gaussPDF(data, mu0(:,i), Sigma0(:,:,i));
            end
            %Compute posterior probability p(i|x)
            Pix_tmp = repmat(Prior0,[numPixels 1]).*Pxi;
            Pix = Pix_tmp ./ repmat(sum(Pix_tmp,2),[1 numState]);
            phi0=Pix(:,1)-Pix(:,2);
            
            
            % 结束计时
            elipsedTime010=toc;
            Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime010;
            
        case 'scribbled_kmeans_2'
            %% scribbled_kmeans_2：第二种：使用用户划线方式生成的有标记数据 + kmeans 方法生成 GMM 参数、初始轮廓。
            
            % 初始轮廓的值类型
            Args0.initializeType = 'staircase';
            
            % 开始计时
            Pros.elipsedEachTime=0;
            tic;
            
            
            load(EachImage.seedsIndex1(index_image).path);
            load(EachImage.seedsIndex2(index_image).path);
            data_foreground=zeros(3,size(seedsIndex1,1));
            data_foreground=data(:,seedsIndex1(:));
            data_background=zeros(3,size(seedsIndex2,1));
            data_background=data(:,seedsIndex2(:));
            
            [~, mu0_foreground,Sigma0_foreground ]= EM_init_kmeans(data_foreground, 1, Pros.maxIterOfKmeans); % Pi：先验概率。1×分类数；均值：维数×分枝数；协方差：维数×维数×分类数
            [~, mu0_background,Sigma0_background ] = EM_init_kmeans(data_background, 1, Pros.maxIterOfKmeans); % Pi：先验概率。1×分类数；均值：维数×分枝数；协方差：维数×维数×分类数
            Prior0(1)=size(data_foreground,2)/(size(data_foreground,2)+size(data_background,2));
            Prior0(2)=size(data_background,2)/(size(data_foreground,2)+size(data_background,2));
            mu0=[mu0_foreground mu0_background];
            Sigma0(:,:,1)=Sigma0_foreground+ 1E-15.*diag(ones(numVar,1));
            Sigma0(:,:,2)=Sigma0_background+ 1E-15.*diag(ones(numVar,1));
            
            % create phi0
            for i=1:numState
                %Compute probability p(x|i)
                Pxi(:,i) = gaussPDF(data, mu0(:,i), Sigma0(:,:,i));
            end
            %Compute posterior probability p(i|x)
            Pix_tmp = repmat(Prior0,[numPixels 1]).*Pxi;
            Pix = Pix_tmp ./ repmat(sum(Pix_tmp,2),[1 numState]);
            phi0=Pix(:,1)-Pix(:,2);
            
            
            % 结束计时
            elipsedTime010=toc;
            Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime010;
            
        case 'scribbled_circle_SDF_1'
            %% scribbled_circle_1 ：第一种：使用 scribbled 生成 GMM 初始参数，用 circle 生成初始轮廓
            
            % 初始轮廓的值类型
            Args0.initializeType = 'SDF';
            
            load(EachImage.seedsIndex1(index_image).path);
            load(EachImage.seedsIndex2(index_image).path);
            data_foreground=zeros(3,size(seedsIndex1,1));
            data_foreground=data(:,seedsIndex1(:));
            data_background=zeros(3,size(seedsIndex2,1));
            data_background=data(:,seedsIndex2(:));
            
            % 开始计时
            Pros.elipsedEachTime=0;
            tic;
            
            [Prior0, mu0,Sigma0 ]= EM_init_kmeans([data_foreground data_background], 2, Pros.maxIterOfKmeans); % Pi：先验概率。1×分类数；均值：维数×分枝数；协方差：维数×维数×分类数
            
            % create phi0
            Pros.circleCenterX=Pros.sizeOfImage(1)/2;
            Pros.circleCenterY=Pros.sizeOfImage(2)/2;
            phi0 = sdf2circle(Pros.sizeOfImage(1),Pros.sizeOfImage(2), Pros.circleCenterX, Pros.circleCenterY, Pros.circleRadius);
            
            
            % 结束计时
            elipsedTime010=toc;
            Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime010;
            
        case 'scribbled_circle_SDF_2'
            %% scribbled_circle_2 ：第二种：使用 scribbled 生成 GMM 初始参数，用 circle 生成初始轮廓
            
            % 初始轮廓的值类型
            Args0.initializeType = 'SDF';
            
            load(EachImage.seedsIndex1(index_image).path);
            load(EachImage.seedsIndex2(index_image).path);
            data_foreground=zeros(3,size(seedsIndex1,1));
            data_foreground=data(:,seedsIndex1(:));
            data_background=zeros(3,size(seedsIndex2,1));
            data_background=data(:,seedsIndex2(:));
            
            % 开始计时
            Pros.elipsedEachTime=0;
            tic;
            
            [~, mu0_foreground,Sigma0_foreground ]= EM_init_kmeans(data_foreground, 1, Pros.maxIterOfKmeans); % Pi：先验概率。1×分类数；均值：维数×分枝数；协方差：维数×维数×分类数
            [~, mu0_background,Sigma0_background ] = EM_init_kmeans(data_background, 1, Pros.maxIterOfKmeans); % Pi：先验概率。1×分类数；均值：维数×分枝数；协方差：维数×维数×分类数
            Prior0(1)=size(data_foreground,2)/(size(data_foreground,2)+size(data_background,2));
            Prior0(2)=size(data_background,2)/(size(data_foreground,2)+size(data_background,2));
            mu0=[mu0_foreground mu0_background];
            Sigma0(:,:,1)=Sigma0_foreground+ 1E-15.*diag(ones(numVar,1));
            Sigma0(:,:,2)=Sigma0_background+ 1E-15.*diag(ones(numVar,1));
            
            % create phi0
            Pros.circleCenterX=Pros.sizeOfImage(1)/2;
            Pros.circleCenterY=Pros.sizeOfImage(2)/2;
            phi0 = sdf2circle(Pros.sizeOfImage(1),Pros.sizeOfImage(2), Pros.circleCenterX, Pros.circleCenterY, Pros.circleRadius);
            
            
            % 结束计时
            elipsedTime010=toc;
            Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime010;
            
            
        case 'scribbled_circle_staircase_1'
            %% scribbled_circle_staircase_1：第一种：使用 scribbled 生成 GMM 初始参数，用 circle 生成初始轮廓，初始轮廓形状用阶梯型
            
            
            % 初始轮廓的值类型
            Args0.initializeType = 'staircase';
            
            load(EachImage.seedsIndex1(index_image).path);
            load(EachImage.seedsIndex2(index_image).path);
            data_foreground=zeros(3,size(seedsIndex1,1));
            data_foreground=data(:,seedsIndex1(:));
            data_background=zeros(3,size(seedsIndex2,1));
            data_background=data(:,seedsIndex2(:));
            
            % 开始计时
            Pros.elipsedEachTime=0;
            tic;
            
            [Prior0, mu0,Sigma0 ]= EM_init_kmeans([data_foreground data_background], 2, Pros.maxIterOfKmeans); % Pi：先验概率。1×分类数；均值：维数×分枝数；协方差：维数×维数×分类数
            
            % create phi0
            Pros.circleCenterX=Pros.sizeOfImage(1)/2;
            Pros.circleCenterY=Pros.sizeOfImage(2)/2;
            phi0 = sdf2circle(Pros.sizeOfImage(1),Pros.sizeOfImage(2), Pros.circleCenterX, Pros.circleCenterY, Pros.circleRadius);
            phi0(phi0>=0)=+Pros.contoursInitValue;
            phi0(phi0<0)=-Pros.contoursInitValue;
            
            % 结束计时
            elipsedTime010=toc;
            Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime010;
            
        case 'scribbled_circle_staircase_2'
            %% scribbled_circle_staircase_2：第二种：使用 scribbled 生成 GMM 初始参数，用 circle 生成初始轮廓，初始轮廓形状用阶梯型
            
            
            % 初始轮廓的值类型
            Args0.initializeType = 'staircase';
            
            load(EachImage.seedsIndex1(index_image).path);
            load(EachImage.seedsIndex2(index_image).path);
            data_foreground=zeros(3,size(seedsIndex1,1));
            data_foreground=data(:,seedsIndex1(:));
            data_background=zeros(3,size(seedsIndex2,1));
            data_background=data(:,seedsIndex2(:));
            
            % 开始计时
            Pros.elipsedEachTime=0;
            tic;
            
            [~, mu0_foreground,Sigma0_foreground ]= EM_init_kmeans(data_foreground, 1, Pros.maxIterOfKmeans); % Pi：先验概率。1×分类数；均值：维数×分枝数；协方差：维数×维数×分类数
            [~, mu0_background,Sigma0_background ] = EM_init_kmeans(data_background, 1, Pros.maxIterOfKmeans); % Pi：先验概率。1×分类数；均值：维数×分枝数；协方差：维数×维数×分类数
            Prior0(1)=size(data_foreground,2)/(size(data_foreground,2)+size(data_background,2));
            Prior0(2)=size(data_background,2)/(size(data_foreground,2)+size(data_background,2));
            mu0=[mu0_foreground mu0_background];
            Sigma0(:,:,1)=Sigma0_foreground+ 1E-15.*diag(ones(numVar,1));
            Sigma0(:,:,2)=Sigma0_background+ 1E-15.*diag(ones(numVar,1));
            
            % create phi0
            Pros.circleCenterX=Pros.sizeOfImage(1)/2;
            Pros.circleCenterY=Pros.sizeOfImage(2)/2;
            phi0 = sdf2circle(Pros.sizeOfImage(1),Pros.sizeOfImage(2), Pros.circleCenterX, Pros.circleCenterY, Pros.circleRadius);
            phi0(phi0>=0)=+Pros.contoursInitValue;
            phi0(phi0<0)=-Pros.contoursInitValue;
            
            % 结束计时
            elipsedTime010=toc;
            Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime010;
            
        case 'circle_SDF'
            %% circle_SDF：用 circle 生成初始轮廓和初始概率项的各参数，初始轮廓形状用SDF
            
            
            % 初始轮廓的值类型
            Args0.initializeType = 'SDF';
            
            
            % 开始计时
            Pros.elipsedEachTime = 0;
            tic;
            
            % create phi0
            Pros.circleCenterX=Pros.sizeOfImage(1)/2;
            Pros.circleCenterY=Pros.sizeOfImage(2)/2;
            phi0 = sdf2circle(Pros.sizeOfImage(1),Pros.sizeOfImage(2), Pros.circleCenterX, Pros.circleCenterY, Pros.circleRadius);
            
            % 生成前景和背景的数据点的索引
            idx_data_foreground=find(phi0>=0);
            idx_data_background = find(phi0<0);
            
            % 计算 Prior, mu, Sigma
            Prior0(1) = length(idx_data_foreground)/numPixels;
            Prior0(2) = length(idx_data_background)/numPixels;
            mu0(:,1) = mean(data(:,idx_data_foreground),2);
            mu0(:,2) = mean(data(:,idx_data_background),2);
            Sigma0(:,:,1) = cov([data(:,idx_data_foreground) data(:,idx_data_foreground)]');
            Sigma0(:,:,1) = Sigma0(:,:,1) + 1E-15.*diag(ones(numVar,1));
            Sigma0(:,:,2) = cov([data(:,idx_data_background) data(:,idx_data_background)]');
            Sigma0(:,:,2) = Sigma0(:,:,2) + 1E-15.*diag(ones(numVar,1));
            
            
            
            % 结束计时
            elipsedTime010 = toc;
            Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime010;
            
        case 'circle_staircase'
            %% circle_staircase：用 circle 生成初始轮廓和初始概率项的各参数，初始轮廓形状用阶梯型
            
            
            % 初始轮廓的值类型
            Args0.initializeType = 'staircase';
            
            
            % 开始计时
            Pros.elipsedEachTime = 0;
            tic;
            
            % create phi0
            Pros.circleCenterX=Pros.sizeOfImage(1)/2;
            Pros.circleCenterY=Pros.sizeOfImage(2)/2;
            phi0 = sdf2circle(Pros.sizeOfImage(1),Pros.sizeOfImage(2), Pros.circleCenterX, Pros.circleCenterY, Pros.circleRadius);
            phi0(phi0>=0)=+Pros.contoursInitValue;
            phi0(phi0<0)=-Pros.contoursInitValue;
            
            % 生成前景和背景的数据点的索引
            idx_data_foreground=find(phi0>=0);
            idx_data_background = find(phi0<0);
            
            % 计算 Prior, mu, Sigma
            Prior0(1) = length(idx_data_foreground)/numPixels;
            Prior0(2) = length(idx_data_background)/numPixels;
            mu0(:,1) = mean(data(:,idx_data_foreground),2);
            mu0(:,2) = mean(data(:,idx_data_background),2);
            Sigma0(:,:,1) = cov([data(:,idx_data_foreground) data(:,idx_data_foreground)]');
            Sigma0(:,:,1) = Sigma0(:,:,1) + 1E-15.*diag(ones(numVar,1));
            Sigma0(:,:,2) = cov([data(:,idx_data_background) data(:,idx_data_background)]');
            Sigma0(:,:,2) = Sigma0(:,:,2) + 1E-15.*diag(ones(numVar,1));
            
            
            
            % 结束计时
            elipsedTime010 = toc;
            Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime010;
            
            
        case 'kmeans'
            %% kmeans：使用 k-means 初始化方式生成初始轮廓和初始概率项的各参数
            
            % 初始轮廓的值类型
            Args0.initializeType = 'staircase';
            
            
            % 开始计时
            Pros.elipsedEachTime = 0;
            tic;
            
            [Prior0, mu0,Sigma0 ]= EM_init_kmeans(data, numState, Pros.maxIterOfKmeans); % Pi：先验概率。1×分类数；均值：维数×分枝数；协方差：维数×维数×分类数
            %Compute probability p(x|i)
            for i=1:numState
                Pxi(:,i) = gaussPDF(data, mu0(:,i), Sigma0(:,:,i));
            end
            
            %Compute posterior probability p(i|x)
            Pix_tmp = repmat(Prior0,[numPixels 1]).*Pxi;
            Pix = Pix_tmp ./ repmat(sum(Pix_tmp,2),[1 numState]);
            
            % create phi0
            phi0=Pix(:,1)-Pix(:,2);
            
            % 结束计时
            elipsedTime010 = toc;
            Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime010;
            
        case 'circle_SDF_kmeans'
            %% circle_SDF_kmeans：使用 circle 作为初始轮廓，初始轮廓形状用阶梯型，k-means 方法生成初始概率项的各参数
            
            
            % 初始轮廓的值类型
            Args0.initializeType = 'SDF';
            
            % 开始计时
            Pros.elipsedEachTime = 0;
            tic;
            
            [Prior0, mu0,Sigma0 ]= EM_init_kmeans(data, numState, Pros.maxIterOfKmeans); % Pi：先验概率。1×分类数；均值：维数×分枝数；协方差：维数×维数×分类数
            
            % create phi0
            Pros.circleCenterX=Pros.sizeOfImage(1)/2;
            Pros.circleCenterY=Pros.sizeOfImage(2)/2;
            phi0 = sdf2circle(Pros.sizeOfImage(1),Pros.sizeOfImage(2), Pros.circleCenterX, Pros.circleCenterY, Pros.circleRadius);
            
            
            % 结束计时
            elipsedTime010 = toc;
            Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime010;
            
        case 'circle_staircase_kmeans'
            %% circle_staircase_kmeans：使用 circle 作为初始轮廓，初始轮廓形状用阶梯型，k-means 方法生成初始概率项的各参数
            
            
            % 初始轮廓的值类型
            Args0.initializeType = 'staircase';
            
            % 开始计时
            Pros.elipsedEachTime = 0;
            tic;
            
            [Prior0, mu0,Sigma0 ]= EM_init_kmeans(data, numState, Pros.maxIterOfKmeans); % Pi：先验概率。1×分类数；均值：维数×分枝数；协方差：维数×维数×分类数
            
            % create phi0
            Pros.circleCenterX=Pros.sizeOfImage(1)/2;
            Pros.circleCenterY=Pros.sizeOfImage(2)/2;
            phi0 = sdf2circle(Pros.sizeOfImage(1),Pros.sizeOfImage(2), Pros.circleCenterX, Pros.circleCenterY, Pros.circleRadius);
            phi0(phi0>=0)=+Pros.contoursInitValue;
            phi0(phi0<0)=-Pros.contoursInitValue;
            
            
            % 结束计时
            elipsedTime010 = toc;
            Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime010;
            
        case 'kmeans_ACMGMM'
            %% kmeans_ACMGMM：借鉴[1] Guowei Gao等人的方法，用k-means初始化，以计算水平集演化
            %% TODO 要改
            
            % 初始轮廓的值类型
            Args0.initializeType = 'staircase';
            
            
            %% 开始计时
            Pros.elipsedEachTime = 0;
            tic;
            
            
            %% k-means初始化
            [Prior0, mu0,Sigma0 ]= EM_init_kmeans(data, numState, Pros.maxIterOfKmeans); % Pi：先验概率。1×分类数；均值：维数×分枝数；协方差：维数×维数×分类数
            
            %% E步：用Θ_k 计算高斯概率p_k
            for i=1:numState
                Pxi(:,i)= gaussPDF(data, mu0(:,i) , Sigma0(:,:,i));
            end
            %% E步：用p_k 和π_k 计算高斯分支的后验期望z_k
            P_x_and_i = repmat(Prior0, [numPixels 1]).*Pxi;		% P_x_and_i：同时满足x和i的概率。图像像素数×分类数
            Px = sum(P_x_and_i,2); % Px：高斯概率密度。图像像素数×1
            Pix = P_x_and_i ./ repmat(Px,[1 numState]); % Pix：后验概率。图像像素数×分类数
            %% M步：用z_k 计算Θ_(k+1)；
            sumPix = sum(Pix);
            for i=1:numState
                % Update the centers
                mu0(:,i) = data*Pix(:,i) / sumPix(i);
                % Update the covariance matrices
                temp_mu = data - repmat(mu0(:,i),1,numPixels);
                Sigma0(:,:,i) = (repmat(Pix(:,i)',numVar, 1) .* temp_mu*temp_mu') / sumPix(i);
                % Add a tiny variance to avoid numerical instability
                Sigma0(:,:,i) = Sigma0(:,:,i) + 1E-15.*diag(ones(numVar,1));
            end
            %% 进行从GMM到ACM的通信：初始代，用式(16)：用z_k 初始化计算嵌入函数\phi_k
            phi0 = Pros.epsilon.*log(Pix(:,1)./Pix(:,2));
            
            
            
            % 结束计时
            elipsedTime010 = toc;
            Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime010;
            
            
        case 'circle_SDF_ACMGMM'
            %% circle_ACMGMM：借鉴[1] Guowei Gao等人的方法，计算水平集演化，用于生成初始轮廓
            %% TODO 要改
            % 初始轮廓的值类型
            Args0.initializeType = 'SDF';
            
            
            % 			%% generate edge indicator functionat gray image.
            % 			image_gray=rgb2gray(image_data);
            % 			G=fspecial('gaussian',Pros.hsize ,Pros.sigma);
            % 			image010_smooth(:,:,1)=conv2(image_gray(:,:),G,'same');  % smooth image by Gaussiin convolution
            % 			[Ix,Iy]=gradient(image010_smooth(:,:,1));
            % 			f=Ix.^2+Iy.^2;
            % 			g=1./(1+f);  % edge indicator function.
            % 			g=reshape(g,[],1);
            % 			data = reshape(image_data ,[],numVar);
            % 			data=data.'; % 要处理的图像数据。维数×像素数
            
            % 初始圆圈轮廓构成的水平集嵌入函数
            circleCenterX=Pros.sizeOfImage(1)/2;
            circleCenterY=Pros.sizeOfImage(2)/2;
            phi0 = sdf2circle(Pros.sizeOfImage(1),Pros.sizeOfImage(2), circleCenterX, circleCenterY, Pros.circleRadius);
            phi0 = reshape(phi0, 1,numPixels);
            
            % 生成前景和背景的数据点的索引
            idx_data_foreground=find(phi0>=0);
            idx_data_background = find(phi0<0);
            % 计算 Prior, mu, Sigma
            Prior0(1) = length(idx_data_foreground)/numPixels;
            Prior0(2) = length(idx_data_background)/numPixels;
            mu0(:,1) = mean(data(:,idx_data_foreground),2);
            mu0(:,2) = mean(data(:,idx_data_background),2);
            Sigma0(:,:,1) = cov([data(:,idx_data_foreground) data(:,idx_data_foreground)]');
            Sigma0(:,:,1) = Sigma0(:,:,1) + Pros.smallNumber.*diag(ones(numVar,1));
            Sigma0(:,:,2) = cov([data(:,idx_data_background) data(:,idx_data_background)]');
            Sigma0(:,:,2) = Sigma0(:,:,2) + Pros.smallNumber.*diag(ones(numVar,1));
            
            % 开始计时
            Pros.elipsedEachTime = 0;
            tic;
            
            %% E步：用Θ_k 计算高斯概率p_k
            for i=1:numState
                Pxi(:,i)= gaussPDF(data, mu0(:,i) , Sigma0(:,:,i), Pros.smallNumber);
            end
            %% E步：用p_k 和π_k 计算高斯分支的后验期望z_k
            P_x_and_i = repmat(Prior0, [numPixels 1]).*Pxi;		% P_x_and_i：同时满足x和i的概率。图像像素数×分类数
            Px = sum(P_x_and_i,2); % Px：高斯概率密度。图像像素数×1
            Pix = P_x_and_i ./ repmat(Px,[1 numState]); % Pix：后验概率。图像像素数×分类数
            %% M步：用z_k 计算Θ_(k+1)；
            sumPix = sum(Pix);
            for i=1:numState
                % Update the centers
                mu0(:,i) = data*Pix(:,i) / sumPix(i);
                % Update the covariance matrices
                temp_mu = data - repmat(mu0(:,i),1,numPixels);
                Sigma0(:,:,i) = (repmat(Pix(:,i)',numVar, 1) .* temp_mu*temp_mu') / sumPix(i);
                % Add a tiny variance to avoid numerical instability
                Sigma0(:,:,i) = Sigma0(:,:,i) + Pros.smallNumber.*diag(ones(numVar,1));
            end
            %% 进行从GMM到ACM的通信：初始代，用式(16)：用z_k 初始化计算嵌入函数\phi_k
            phi0 = Pros.epsilon.*log(Pix(:,1)./Pix(:,2));
            % 生成前景和背景的数据点的索引
            idx_data_foreground=find(phi0>=0);
            idx_data_background = find(phi0<0);
            % 计算 Prior, mu, Sigma
            Prior0(1) = length(idx_data_foreground)/numPixels;
            Prior0(2) = length(idx_data_background)/numPixels;
            mu0(:,1) = mean(data(:,idx_data_foreground),2);
            mu0(:,2) = mean(data(:,idx_data_background),2);
            Sigma0(:,:,1) = cov([data(:,idx_data_foreground) data(:,idx_data_foreground)]');
            Sigma0(:,:,1) = Sigma0(:,:,1) + Pros.smallNumber.*diag(ones(numVar,1));
            Sigma0(:,:,2) = cov([data(:,idx_data_background) data(:,idx_data_background)]');
            Sigma0(:,:,2) = Sigma0(:,:,2) + Pros.smallNumber.*diag(ones(numVar,1));
            
            
            % 结束计时
            elipsedTime010 = toc;
            Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime010;
            
            
        otherwise
            error('error at choose evolution method !');
    end  % end this evolution method
    
    %% 保存相关参数
    folderpath_contourImage = fullfile(Pros.folderpath_initResources, 'contour images');
    if ~exist(folderpath_contourImage,'dir')
        mkdir(folderpath_contourImage);
    end
    
    % 保存轮廓二值图
    filename_contourImage = [EachImage.originalImage(index_image).name(1:end-4) '_contour.bmp']; % 原始图像名称;
    filepath_contourImage = fullfile(folderpath_contourImage, filename_contourImage);
    phiData = reshape(phi0,  Pros.sizeOfImage(1), Pros.sizeOfImage(2));
    bwData=zeros(Pros.sizeOfImage(1),Pros.sizeOfImage(2));
    bwData(phiData>=0)=1;
    bwData = im2bw(bwData);
    imwrite(bwData, filepath_contourImage,'bmp');
    
    % 保存phi0
    phi0=phiData;
    folderpath_phi = fullfile(Pros.folderpath_initResources, 'phi');
    if ~exist(folderpath_phi,'dir')
        mkdir(folderpath_phi);
    end
    filename_phi = [EachImage.originalImage(index_image).name(1:end-4) '_phi.mat'];
    filepath_phi = fullfile(folderpath_phi, filename_phi);
    save(filepath_phi, 'phi0');
    
    % 保存elipsedEachTime
    time0=Pros.elipsedEachTime;
    folderpath_time = fullfile(Pros.folderpath_initResources, 'time');
    if ~exist(folderpath_time,'dir')
        mkdir(folderpath_time);
    end
    filename_time = [EachImage.originalImage(index_image).name(1:end-4) '_time.mat'];
    filepath_time = fullfile(folderpath_time, filename_time);
    save(filepath_time, 'time0');
    
    % 保存先验Prior
    folderpath_prior = fullfile(Pros.folderpath_initResources, 'prior');
    if ~exist(folderpath_prior,'dir')
        mkdir(folderpath_prior);
    end
    filename_prior = [EachImage.originalImage(index_image).name(1:end-4) '_prior.mat'];
    filepath_prior = fullfile(folderpath_prior, filename_prior);
    save(filepath_prior, 'Prior0');
    
    % 保存均值mu
    folderpath_mu = fullfile(Pros.folderpath_initResources, 'mu');
    if ~exist(folderpath_mu,'dir')
        mkdir(folderpath_mu);
    end
    filename_mu = [EachImage.originalImage(index_image).name(1:end-4) '_mu.mat'];
    filepath_mu = fullfile(folderpath_mu, filename_mu);
    save(filepath_mu,'mu0');
    
    % 保存协方差Sigma
    folderpath_Sigma = fullfile(Pros.folderpath_initResources, 'Sigma');
    if ~exist(folderpath_Sigma,'dir')
        mkdir(folderpath_Sigma);
    end
    filename_Sigma = [EachImage.originalImage(index_image).name(1:end-4) '_Sigma.mat'];
    filepath_Sigma = fullfile(folderpath_Sigma, filename_Sigma);
    save(filepath_Sigma, 'Sigma0');
    
    
end

% 保存Args
folderpath_Args = fullfile(Pros.folderpath_initResources, 'Args');
if ~exist(folderpath_Args,'dir')
    mkdir(folderpath_Args);
end
filename_Args = 'Args.mat';
filepath_Args = fullfile(folderpath_Args, filename_Args);
save(filepath_Args, 'Args0');


%%
text=['程序运行完毕。'];
disp(text)
sp.Speak(text)
%% 停止记录公共窗口输出的数据并保存
diary off;




