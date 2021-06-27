% function [] = segmentation_func(evolutionMethod, mardType, initMethod, foldername_EachImageBaseFolder, foldername_ResultsBaseFolder, proportionPixelsToEndLoop)
function [] = segmentation_func(Args)
% segmentation_eachIter.m 用于分割一组参数的图像

%% 简介：
% 用于对一批图像用不同的分割算法分割图像并生成相应结果。用于后续分析。程序每次运行调用一种分割算法的给定的一组参数值处理一批图像。
% Reference :
...Guowei Gao ,Chenglin Wen ,Huibin Wang, Fast and robust image segmentation with active contours and Student's-t mixture model
    
...资源放在 resources 文件夹中
    ...结果放在 results 文件夹中
    
%% 注意事项：


%% 预处理
close all;
clc;
diary off;
sp=actxserver('SAPI.SpVoice');
% addpath( genpath( '.' ) ); %添加当前路径下的所有文件夹以及子文件夹



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% 构建管理文件夹resource的结构体EachImage 和构建存储历次实验的results文件夹里的文件路径和名称的结构体 Results
Pros = Args; % 把Args现有的一系列参数赋给Pros

EachImage = createEachImageStructureForSegmentation(Pros.folderpath_EachImageResourcesBaseFolder, Pros.folderpath_EachImageInitBaseFolder, Pros.numUselessFiles);

% input('确认文件夹里的文件数量是否正确？正确按任意键继续，否则按 Ctrl+c 终止程序。')

% indexOfScribbledImageFolder = findIndexOfFolderName(EachImage, 'scribbled images');
% indexOfOriginalImageFolder = findIndexOfFolderName(EachImage, 'original images');
% indexOfBwImageFolder = findIndexOfFolderName(EachImage, 'bw images');
% indexOfGTFolder = findIndexOfFolderName(EachImage, 'ground truth bw images');
% indexOfEvaluationsFolder = findIndexOfFolderName(EachImage, 'evaluations');



% Results = createResultsStructure(Pros.folderpath_ResultsBaseFolder ,Pros.numUselessFiles);

%% 读取初始化信息的 Args0 文件并赋值
load(EachImage.Args(1).path);
Args.initializeType = Args0.initializeType ;
clear Args0;
Pros = Args; % 把Args现有的一系列参数赋给Pros

%% 构建本次实验的文件夹，并进行实验
% Pros.foldername_eachIndexOfExperiment=dir(Pros.folderpath_ResultsBaseFolder);	% 每次实验的文件夹列表
% Pros.index_experiment=Results.num_experiments+1;

% 生成试验编号文件夹
% switch Pros.outputMode
%     case 'datatime'
%         % 建立一个名称为年月日时分秒的数据文件夹用于每一次的实验的输出
%         % 格式1
%         %                 Pros.foldername_experiment=[Pros.evolutionMethod '_' datestr(now,'ddHHMMSS')];
%         % 格式2
%         switch Pros.evolutionMethod
%             case 'GMM'
%                 Pros.foldername_experiment=[Pros.evolutionMethod '_numState' num2str(Pros.numOfComponents) '_end' num2str(Pros.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMMSS')];
%             case 'CV'
%                 Pros.foldername_experiment=[Pros.evolutionMethod '_step' num2str(Pros.timestep) '_beta' num2str(Pros.beta) '_epsilon' num2str(Pros.epsilon) '_end' num2str(Pros.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMMSS')];
%             otherwise
%                 %                         				Pros.foldername_experiment=[Pros.evolutionMethod '_step' num2str(Pros.timestep) '_beta' num2str(Pros.beta) '_epsilon' num2str(Pros.epsilon) '_hsize' num2str(Pros.hsize) '_sigma' num2str(Pros.sigma) '_end' num2str(Pros.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMMSS')];
%                 %                 Pros.foldername_experiment=[Pros.evolutionMethod '_nu' num2str(Pros.nu) '_' datestr(now,'ddHHMMSS')];
%                 Pros.foldername_experiment=[Pros.evolutionMethod '_' Pros.weight_Eacm '_' datestr(now,'ddHHMMSS')];
%                 Pros.foldername_experiment=[Pros.evolutionMethod '_' datestr(now,'ddHHMMSS')];
%         end
%     case 'index'
%         Pros.foldername_experiment = ['第' num2str(index_experiment) '次实验'];
% end

Pros.folderpath_experiment=fullfile(Pros.folderpath_ResultsBaseFolder, Pros.foldername_experiment);
mkdir(Pros.folderpath_experiment);

% 生成diary输出文件夹
Pros.foldername_diary = 'diary output';
Pros.folderpath_diary = fullfile(Pros.folderpath_experiment, Pros.foldername_diary);
if ~exist(Pros.folderpath_diary,'dir')
    mkdir(Pros.folderpath_diary );
end

%% 开启 diary 记录
Pros.filepath_diary = fullfile(Pros.folderpath_diary , ['diary.txt']);
diary(Pros.filepath_diary);
diary on;
Args % 打印 Args

% 选择需要的 markType
switch Pros.markType
    case 'scribble'
        num_processedImages = EachImage.num_scribbledImage;
    case 'contour'
        num_processedImages = EachImage.num_contourImage;
    case 'original'
        num_processedImages = EachImage.num_originalImage;
    otherwise
        error('error at choose mark type !');
end



% 建立处理每个标记图像之后的Args信息文件夹路径
Pros.folderpath_ArgsOutput = fullfile(Pros.folderpath_experiment, 'Args output');
if ~exist(Pros.folderpath_ArgsOutput ,'dir')
    mkdir(Pros.folderpath_ArgsOutput);
end

% 最终分割二值图截图文件夹路径
Pros.folderpath_bwImage = fullfile(Pros.folderpath_experiment, 'bw images');
if ~exist(Pros.folderpath_bwImage,'dir')
    mkdir(Pros.folderpath_bwImage);
end

% 最终分割二值图数据文件夹路径
Pros.folderpath_bwData = fullfile(Pros.folderpath_experiment, 'bw data');
if ~exist(Pros.folderpath_bwData,'dir')
    mkdir(Pros.folderpath_bwData);
end

% 最终嵌入函数数据文件夹路径
Pros.folderpath_phiData = fullfile(Pros.folderpath_experiment, 'phi data');
if ~exist(Pros.folderpath_phiData,'dir')
    mkdir(Pros.folderpath_phiData);
end

% 建立处理每个标记图像之后的输出数据文件夹路径
Pros.folderpath_writeData=fullfile(Pros.folderpath_experiment, 'write data');
if ~exist(Pros.folderpath_writeData,'dir')
    mkdir(Pros.folderpath_writeData);
end

% 建立处理每个标记图像之后的结果图文件夹路径
Pros.folderpath_screenShot=fullfile(Pros.folderpath_experiment, 'screen shot');
if ~exist(Pros.folderpath_screenShot,'dir')
    mkdir(Pros.folderpath_screenShot);
end

% 建立处理每个标记图像的标记种子数据文件夹路径
Pros.folderpath_seeds=fullfile(Pros.folderpath_experiment, 'seeds data');
if ~exist(Pros.folderpath_seeds,'dir')
    mkdir(Pros.folderpath_seeds);
end

% 建立处理每个标记图像之后的输出评价指标 time 、 iteration 的数据文件夹路径
Pros.folderpath_evaluation=fullfile(Pros.folderpath_experiment, 'evaluation data');
if ~exist(Pros.folderpath_evaluation,'dir')
    mkdir(Pros.folderpath_evaluation);
end

% 开始记录总时间
startTotalTime = clock;
totalIteration = 0;
elipsedTime = 0;

elipsedEachTime.name=cell(num_processedImages,1);
elipsedEachTime.time =zeros(num_processedImages,1);
elipsedEachTime.iteration = zeros(num_processedImages,1);

%% 设置用于测试方法的处理图像的个数
if strcmp(Pros.isTestOnlyFewImages,'yes')
    array_processedImages=(1:Pros.numImagesToTest) ;
else
    array_processedImages=(1:num_processedImages);
end

if strcmp(Pros.isRunArrayProcessedImages,'yes')
    array_processedImages=Args.arrayProcessedImages;
else
    array_processedImages=(1:num_processedImages);
end

for index_processedImage = array_processedImages
    disp(['处理图像：' num2str(index_processedImage) '/' num2str(num_processedImages)]);
    
    %% 读取图像并显示
    index_originalImage = findIndexOfOriginalImageAtEachScribbledImage(EachImage, index_processedImage, 'mark');
    Pros.filename_originalImage =  EachImage.originalImage(index_originalImage).name; % 原始图像名称;
    Pros.filepath_originalImage =EachImage.originalImage(index_originalImage).path;
    image010_original = imread(Pros.filepath_originalImage);
    % properties setting
    Pros.sizeOfImage=size(image010_original);
    Pros.numData = Pros.sizeOfImage(1).*Pros.sizeOfImage(2);
    
    %% 不同初始化模式的显示
    switch Pros.markType
        case 'scribble'
            markTypeName = '涂鸦';
            Pros.filename_processedImage =EachImage.scribbledImage(index_processedImage).name;
            Pros.filepath_processedImage =EachImage.scribbledImage(index_processedImage).path;
            % 读取初始化轮廓的先验信息、均值、协方差
            Pros.filename_Prior = EachImage.prior(index_processedImage).name;
            Pros.filepath_Prior = EachImage.prior(index_processedImage).path;
            load(Pros.filepath_Prior);
            Pros.filename_mu = EachImage.mu(index_processedImage).name;
            Pros.filepath_mu = EachImage.mu(index_processedImage).path;
            load(Pros.filepath_mu);
            Pros.filename_Sigma = EachImage.Sigma(index_processedImage).name;
            Pros.filepath_Sigma = EachImage.Sigma(index_processedImage).path;
            load(Pros.filepath_Sigma);
            % 读取初始化轮廓的耗费时间
            Pros.filename_time= EachImage.time(index_processedImage).name;
            Pros.filepath_time = EachImage.time(index_processedImage).path;
            load(Pros.filepath_time);
            Pros.elipsedEachTime = time0;
            % 读取初始化轮廓的初始水平集嵌入函数phi0
            Pros.filename_phi= EachImage.phi(index_processedImage).name;
            Pros.filepath_phi= EachImage.phi(index_processedImage).path;
            load(Pros.filepath_phi);
            % 初始水平集嵌入函数phi0预处理为上下限
            if 1==strcmp('yes' ,Pros.isMinMaxInitContours)
                phi0=reshape(mapminmax(reshape(phi0,1,[]), Pros.contoursInitMinValue, Pros.contoursInitMaxValue), Pros.sizeOfImage(1), Pros.sizeOfImage(2));
            end
            % 获取有标记数据、无标记数据
            load(EachImage.seedsIndex1(index_processedImage).path);
            load(EachImage.seedsIndex2(index_processedImage).path);
            [seedsIndex1_x,seedsIndex1_y]=ind2sub([Pros.sizeOfImage(1),Pros.sizeOfImage(2)],seedsIndex1);
            [seedsIndex2_x,seedsIndex2_y]=ind2sub([Pros.sizeOfImage(1),Pros.sizeOfImage(2)],seedsIndex2);
            
        case 'contour'
            markTypeName = '轮廓';
            Pros.filename_processedImage =EachImage.contourImage(index_processedImage).name;
            Pros.filepath_processedImage =EachImage.contourImage(index_processedImage).path;
            % 读取初始化轮廓的先验信息、均值、协方差
            Pros.filename_Prior = EachImage.prior(index_processedImage).name;
            Pros.filepath_Prior = EachImage.prior(index_processedImage).path;
            load(Pros.filepath_Prior);
            Pros.filename_mu = EachImage.mu(index_processedImage).name;
            Pros.filepath_mu = EachImage.mu(index_processedImage).path;
            load(Pros.filepath_mu);
            Pros.filename_Sigma = EachImage.Sigma(index_processedImage).name;
            Pros.filepath_Sigma = EachImage.Sigma(index_processedImage).path;
            load(Pros.filepath_Sigma);
            % 读取初始化轮廓的耗费时间
            Pros.filename_time= EachImage.time(index_processedImage).name;
            Pros.filepath_time = EachImage.time(index_processedImage).path;
            load(Pros.filepath_time);
            Pros.elipsedEachTime = time0;
            % 读取初始化轮廓的初始水平集嵌入函数phi0
            Pros.filename_phi= EachImage.phi(index_processedImage).name;
            Pros.filepath_phi= EachImage.phi(index_processedImage).path;
            load(Pros.filepath_phi);
            % 初始水平集嵌入函数phi0预处理为上下限
            if Pros.isMinMaxInitContours
                phi0=reshape(mapminmax(reshape(phi0,1,Pros.numData), Pros.contoursInitMinValue, Pros.contoursInitMaxValue), Pros.sizeOfImage(1), Pros.sizeOfImage(2));
            end
            
            
        case 'original'
            markTypeName = '原图';
            Pros.filename_processedImage = EachImage.originalImage(index_processedImage).name;
            Pros.filepath_processedImage =EachImage.originalImage(index_processedImage).path;
            
            
        otherwise
            error('error at choose mark type !');
    end
    
    % 集中设置 Pros
    Pros.iteration_inner=Args.iteration_inner;
    Pros.iteration_outer=Args.iteration_outer;
    Pros.filename_ArgsOutput = [Pros.filename_processedImage(1:end-4) '_Args.mat'];
    Pros.filepath_ArgsOutput = fullfile(Pros.folderpath_ArgsOutput, Pros.filename_ArgsOutput);
    Pros.filename_bwImage = [Pros.filename_processedImage(1:end-4) '_iteration_' num2str(Pros.iteration_outer) '_bwImage.bmp'];
    Pros.filepath_bwImage = fullfile(Pros.folderpath_bwImage, Pros.filename_bwImage);
    Pros.filename_bwData = [Pros.filename_processedImage(1:end-4) '_iteration_' num2str(Pros.iteration_outer) '_bwData.mat'];
    Pros.filepath_bwData = fullfile(Pros.folderpath_bwData, Pros.filename_bwData);
    Pros.filename_phiData = [Pros.filename_processedImage(1:end-4) '_iteration_' num2str(Pros.iteration_outer) '_phiData.mat'];
    Pros.filepath_phiData = fullfile(Pros.folderpath_phiData, Pros.filename_phiData);
    Pros.filename_writeData =  [Pros.filename_processedImage(1:end-4) '_iteration_' num2str(Pros.iteration_outer) '_ExportData.mat'];
    Pros.filepath_writeData = fullfile(Pros.folderpath_writeData, Pros.filename_writeData);
    Pros.index_exportData = 1;
    
    %% 读取图像并显示
    image010_processed = imread(Pros.filepath_processedImage);
    
    
    %% 开始主程序
    text = ['开始图像 ' Pros.filename_originalImage ' 的' markTypeName '模式下 ' Pros.filename_processedImage ' 的实验...'];
    if strcmp(Pros.isVoice,'yes')==1
        sp.Speak(text);
    end
    disp(text);
    
    
    
    %% 显示Args
    % 设置要打印到屏幕的信息
    Args.originalImageName =Pros.filename_originalImage ;
    Args.processedImageNmae = Pros.filename_processedImage ;
    Args.nameOfExperiment =Pros.foldername_experiment ;
    Pros.Args = Args; % 把最终的Args赋给Pros，用于存储Args的数据
    disp(['原始图像' Args.originalImageName]) % 向屏幕输出原始图像名称
    disp(['处理图像' Args.processedImageNmae]) % 向屏幕输出处理图像名称
    
    Pros.numPixelChangedToContinue = Pros.proportionPixelsToEndLoop.*Pros.numData;	% 停机条件之一。在演化过程中如果出现两代之间的前背景的改变的像素数量小于这个值，就允许继续循环
        
    
    %% start level set evolution
    switch Pros.evolutionMethod
        case 'semiACMGMMSP_2'
            %% ACMGMM+semisupervised+SP 方案2 ：在[1]的基础上，引入交互半监督，并借鉴[2] X. Zhou, X. Li and W. Hu等人的方法，把超像素力引入水平集。
            [Pros, phi] = evolution_ACMGMMandSPsemisupervised_2( Pros, image010_original ,image010_processed, seedsIndex1, seedsIndex2, phi0, Prior0, mu0, Sigma0 );
            
        case 'semiACMGMMSP_2_2'
            %% ACMGMM+semisupervised+SP 方案2 ：在[1]的基础上，引入交互半监督，并借鉴[2] X. Zhou, X. Li and W. Hu等人的方法，把超像素力引入水平集。
            [Pros, phi] = evolution_ACMGMMandSPsemisupervised_2_2( Pros, image010_original ,image010_processed, seedsIndex1, seedsIndex2, phi0, Prior0, mu0, Sigma0 );
            
        case 'semiACMGMMSP_1'
            %% ACMGMM+semisupervised+SP 方案1 ：在[1]的基础上，引入交互半监督，并借鉴[2] X. Zhou, X. Li and W. Hu等人的方法，把超像素力引入水平集。
            [Pros, phi] = evolution_ACMGMMandSPsemisupervised_1( Pros, image010_original ,image010_processed, seedsIndex1, seedsIndex2, phi0, Prior0, mu0, Sigma0 );
            
        case 'semiACMGMMSP_1_2'
            %% ACMGMM+semisupervised+SP 方案1 ：在[1]的基础上，引入交互半监督，并借鉴[2] X. Zhou, X. Li and W. Hu等人的方法，把超像素力引入水平集。
            [Pros, phi] = evolution_ACMGMMandSPsemisupervised_1_2( Pros, image010_original ,image010_processed, seedsIndex1, seedsIndex2, phi0, Prior0, mu0, Sigma0 );
            
            
        case 'semiACMGMM'
            %% ACM&GMM+Semi-supurvised : 实现基于 [1] 的方法，将 [3] 生成式方法引入
            [ Pros, phi ] = evolution_ACMGMMandSemisupervised( Pros, image010_original ,image010_processed , seedsIndex1,seedsIndex2, phi0, Prior0, mu0, Sigma0);
            
        case 'semiACMGMM_Eacm'
            %% ACM&GMM+Semi-supurvised with Huang Tan 的新能量项
            [ Pros, phi ] = evolution_ACMGMMandSemisupervised_Eacm( Pros, image010_original ,image010_processed , seedsIndex1,seedsIndex2, phi0, Prior0, mu0, Sigma0);
            
            
        case 'semiACM_Eacm'
            %% Semi-supurvised only with Huang Tan 的新能量项
            %% TODO
            [ Pros, phi ] = evolution_ACMandSemisupervised_Eacm( Pros, image010_original ,image010_processed , seedsIndex1, seedsIndex2, phi0, Prior0, mu0, Sigma0);
            
            
        case 'semiACM_HuangTan'
            %% 谭煌老师的水平集演化方法
            [Pros, phi] = evolution_ACMandSemisupervised_HuangTan( Pros, image010_original, image010_processed, seedsIndex1, seedsIndex2, phi0 );
            
        case 'ACM_SP'
            %% ACM+SP ：实现[2] X. Zhou, X. Li and W. Hu等人的方法，超像素力引入水平集。
            [Pros, phi] = evolution_ACMandSP( Pros, image010_original ,image010_processed, phi0);
            
            
        case 'ACMGMM'
            %% ACM&GMM new： 借鉴[1] Guowei Gao等人的方法，计算水平集演化，先验计算用式(25)
            [ Pros, phi] = evolution_ACMandGMMnew_pi2(Pros,  image010_original, image010_processed, phi0, Prior0, mu0, Sigma0);
            
        case 'ACMGMMpi1'
            %% ACM&GMM pi 1：借鉴[1] Guowei Gao等人的方法，计算水平集演化，先验计算用式(23)
            [ Pros, phi] = evolution_ACMandGMM_pi1(Pros,  image010_original, image010_processed);
            
        case 'ACMGMMpi2'
            %% ACM&GMM pi 2：借鉴[1] Guowei Gao等人的方法，计算水平集演化，先验计算用式(25)
            [ Pros, phi] = evolution_ACMandGMM_pi2(Pros,  image010_original, image010_processed);
            
        case 'ACMandGM'
            %% ACM&GM： [5]第二节的方法，计算水平集演化
            [ Pros, phi ] = evolution_ACMandGM(Pros,  image010_original, image010_processed, phi0);
            
        case 'semiCV'
            %% CV：使用扩展到彩色空间的CV模型的，半监督的方法，计算水平集演化
            %% TODO
            %   Matlad code implementing Chan-Vese model in the paper 'Active Contours Without Edges'
            %   Author: Chunming Li, all right reserved
            %   email: li_chunming@hotmail.com
            %   URL:   http://www.engr.uconn.edu/~cmli
            [ Pros, phi, heaviside_phi, dirac_phi]  = evolution_CV(Pros,  image010_original, image010_processed, phi0);   % update level set function
            
            
        case 'CV'
            %% CV：使用扩展到彩色空间的CV模型的方法，计算水平集演化
            %   Matlad code implementing Chan-Vese model in the paper 'Active Contours Without Edges'
            %   Author: Chunming Li, all right reserved
            %   email: li_chunming@hotmail.com
            %   URL:   http://www.engr.uconn.edu/~cmli
            [ Pros, phi, heaviside_phi, dirac_phi]  = evolution_CV(Pros,  image010_original, image010_processed, phi0);   % update level set function
            
            
        case 'CVgray'
            %% CV gray：使用传统的处理灰度图像的CV模型的方法，计算水平集演化
            %   Matlad code implementing Chan-Vese model in the paper 'Active Contours Without Edges'
            %   Author: Chunming Li, all right reserved
            %   email: li_chunming@hotmail.com
            %   URL:   http://www.engr.uconn.edu/~cmli
            [ Pros, phi, heaviside_phi, dirac_phi]  = evolution_CV_gray(Pros,  image010_original, image010_processed, phi0);   % update level set function
            
        case 'semiGMM'
            %% GMM：使用GMM的半监督二相分割
            %% TODO
            
        case 'GMM'
            %% GMM：使用GMM的二相分割
            [Pros, phi] = evolution_GMM(Pros, image010_original, image010_processed, Prior0, mu0, Sigma0);
            
        case 'ACMandGMMtoEq18'
            %% ACMandGMMtoEq18：此方案是借鉴[1]的方法，但是不引入关于(23)(25)式的先验信息，而只用到(18)：
            % 轮廓演化一代得到新一代轮廓
            [Pros, phi ] = evolution_ACMandGMMtoEq18(Pros,  image010_original, image010_processed);
            
            
            
        case 'LBF'
            %% LBF：使用改进为处理彩色图像的LBF方法，计算水平集演化
            %本程序用来演化水平集函数，详见文章：C. Li, C. Kao, J.C. Gore, Z. Ding. Minimization of region-scalable fitting energy for image segmentation.
            %IEEE Transaction on Image Processing, 2008, 17(10):1940-1949.
            %phi为水平集函数，I为图像,Ksigma为核函数,nu长度权值,timestep时间步长,mu符号距离函数权值
            %lambda1和lambda2为权值，epsilon控制阶跃和冲击函数
            %By Liushigang.
            [ Pros, phi, heaviside_phi, dirac_phi ] = evolution_LBF(Pros, image010_original, image010_processed, phi0);
            
            
        case 'LBFgray'
            %% LBF gray：使用传统的处理灰度图像的LBF方法，计算水平集演化
            %本程序用来演化水平集函数，详见文章：C. Li, C. Kao, J.C. Gore, Z. Ding. Minimization of region-scalable fitting energy for image segmentation.
            %IEEE Transaction on Image Processing, 2008, 17(10):1940-1949.
            %phi为水平集函数，I为图像,Ksigma为核函数,nu长度权值,timestep时间步长,mu符号距离函数权值
            %lambda1和lambda2为权值，epsilon控制阶跃和冲击函数
            %By Liushigang.
            [ Pros, phi, heaviside_phi, dirac_phi ] = evolution_LBF_gray(Pros, image010_original, image010_processed, phi0);
            
            
        case 'semiLIF'
            %% LIF：使用改进为处理彩色图像的LIF方法，计算水平集演化
            % This Matlab file demomstrates a level set algorithm based on Kaihua Zhang et al's paper:
            %    "Active contours driven by local image fitting energy" published by pattern recognition (2009)
            % Author: Kaihua Zhang, all rights reserved
            % E-mail: zhkhua@mail.ustc.edu.cn
            % http://www4.comp.polyu.edu.hk/~cslzhang/
            %  Notes:
            %   1. Some parameters may need to be modified for different types of images. Please contact the author if any problem regarding the choice of parameters.
            %   2. Intial contour should be set properly.
            %% TODO
            
        case 'LIF'
            %% LIF：使用改进为处理彩色图像的LIF方法，计算水平集演化
            % This Matlab file demomstrates a level set algorithm based on Kaihua Zhang et al's paper:
            %    "Active contours driven by local image fitting energy" published by pattern recognition (2009)
            % Author: Kaihua Zhang, all rights reserved
            % E-mail: zhkhua@mail.ustc.edu.cn
            % http://www4.comp.polyu.edu.hk/~cslzhang/
            %  Notes:
            %   1. Some parameters may need to be modified for different types of images. Please contact the author if any problem regarding the choice of parameters.
            %   2. Intial contour should be set properly.
            [ Pros, phi] = evolution_LIF(Pros, image010_original, image010_processed, phi0);
            
            
        case 'LIFgray'
            %% LIF gray：使用传统的处理灰度图像的LIF方法，计算水平集演化
            % This Matlab file demomstrates a level set algorithm based on Kaihua Zhang et al's paper:
            %    "Active contours driven by local image fitting energy" published by pattern recognition (2009)
            % Author: Kaihua Zhang, all rights reserved
            % E-mail: zhkhua@mail.ustc.edu.cn
            % http://www4.comp.polyu.edu.hk/~cslzhang/
            %  Notes:
            %   1. Some parameters may need to be modified for different types of images. Please contact the author if any problem regarding the choice of parameters.
            %   2. Intial contour should be set properly.
            [ Pros, phi, heaviside_phi, dirac_phi ] = evolution_LIF_gray(Pros, image010_original, image010_processed, phi0);
            
            
        case 'DRLSE'
            %% DRLSE：使用李春明的DRLSE的方法，计算水平集演化
            %% generate edge indicator function.
            %% TODO
            image010_gray =256.* image010_processed(:,:,1);
            G=fspecial('gaussian',Args.hsize ,Args.sigma);
            image010_smooth=conv2(image010_gray,G,'same');  % smooth image by Gaussiin convolution
            [Ix,Iy]=gradient(image010_smooth);
            f=Ix.^2+Iy.^2;
            g=1./(1+f);  % edge indicator function.
            
            % 初始化轮廓
            phi = phi0;
            
            [Pros, phi] = visualizeContours_DRLSE( phi, image010_original, image010_data, Pros,Results );
            
            while Pros.iteration_outer<=Args.numIteration_outer
                %% 轮廓演化一代得到新一代轮廓
                [Pros, phi] = evolution_DRLSE( phi, g, Args,Pros );
                
                %% visualization
                Pros = visualizeContours_DRLSE( phi, image010,Args,Pros,Results );
                %%
                Pros.iteration_outer=Pros.iteration_outer+1;
            end
            
            
        otherwise
            error('error at choose evolution method !');
    end  % end this evolution method
    
    %% 计时每个图像处理时间
    elipsedEachTime(index_processedImage).name = Pros.filename_originalImage(1:end-4) ;
    elipsedEachTime(index_processedImage).time = Pros.elipsedEachTime;
    elipsedEachTime(index_processedImage).iteration = Pros.iteration_outer-1;
    elipsedTime = elipsedTime+elipsedEachTime(index_processedImage).time ;
    remainingTime = (elipsedTime/index_processedImage)*(num_processedImages - index_processedImage);
    totalIteration = totalIteration+Pros.iteration_outer-1;
    disp(['单个图像处理时间： ' num2str(elipsedEachTime(index_processedImage).time) ' 秒'])
    disp(['演化代数： ' num2str(elipsedEachTime(index_processedImage).iteration)])
    disp(['预计剩余时间： ' num2str(remainingTime) ' 秒'])
    
    %% 写出关键的数据
    Pros.filename_bwImageEnd = [Pros.filename_processedImage(1:end-4) '_' Pros.evolutionMethod  '_iter' num2str(Pros.iteration_outer-1) '_time' num2str(Pros.elipsedEachTime) '_bwImg.bmp'];
    Pros.filepath_bwImageEnd = fullfile(Pros.folderpath_bwImage, Pros.filename_bwImageEnd);
    Pros.filename_bwDataEnd = [Pros.filename_processedImage(1:end-4) '_' Pros.evolutionMethod '_iter' num2str(Pros.iteration_outer-1) '_time' num2str(Pros.elipsedEachTime) '_bwData.mat'];
    Pros.filepath_bwDataEnd = fullfile(Pros.folderpath_bwData, Pros.filename_bwDataEnd);
    Pros.filename_phiDataEnd = [Pros.filename_processedImage(1:end-4) '_' Pros.evolutionMethod '_iter' num2str(Pros.iteration_outer-1) '_time' num2str(Pros.elipsedEachTime) '_phiData.mat'];
    Pros.filepath_phiDataEnd = fullfile(Pros.folderpath_phiData, Pros.filename_phiDataEnd);
    
    % 写出最终嵌入函数数据
    phiData = reshape(phi,  Pros.sizeOfImage(1), Pros.sizeOfImage(2));
    %     save(Pros.filepath_phiDataEnd,'phiData');         % 不保存 phiData
    if exist(Pros.filepath_phiDataEnd,'file')
        disp(['已保存最终嵌入函数数据 ' Pros.filename_phiDataEnd]);
    else
        disp(['未保存最终嵌入函数数据 ' Pros.filename_phiDataEnd]);
    end
    
    % 生成\phi 分割得到的二值图数据
    bwData=zeros(Pros.sizeOfImage(1),Pros.sizeOfImage(2));
    bwData(phiData(:)>=0)=1;
    bwData = im2bw(bwData);
    % 保存最终分割二值图
    imwrite(bwData, Pros.filepath_bwImageEnd,'bmp');
    if exist(Pros.filepath_bwImageEnd,'file')
        disp(['已保存最终分割二值图 ' Pros.filename_bwImageEnd]);
    else
        disp(['未保存最终分割二值图 ' Pros.filename_bwImageEnd]);
    end
    
    
    disp(' ')
    
    %% 存储 Args
    Args.elipsedTimes = elipsedEachTime(index_processedImage).time;
    Args.iterations =  elipsedEachTime(index_processedImage).iteration;
    save(Pros.filepath_ArgsOutput, 'Args'); % 保存Args成mat文件
    
    pause(0.5);
end % end marked image

%% save data of elipsed total time and average iteration and each elipsed time and iteration.
averageIteration = totalIteration/num_processedImages;
% Pros.filepath_elipsedEachTime = fullfile(Pros.folderpath_evaluation , ['time' num2str(elipsedTime) '_iter' num2str(averageIteration) '.mat']);
Pros.filepath_elipsedEachTime = fullfile(Pros.folderpath_evaluation , ['time.mat']);
elipsedEachTime=struct2table(elipsedEachTime);
save(Pros.filepath_elipsedEachTime,'elipsedEachTime');
disp(' ')

%% 程序结束提醒
elapsedTotalTime = etime(clock,startTotalTime);
disp(['平均演化代数： ' num2str(averageIteration)])
disp(['运行时间：' num2str(elapsedTotalTime) '秒。'])
text=['程序运行完毕。'];
% text=['程序运行完毕。运行时间：' num2str(elapsedTotalTime) '秒。'];
disp(text);
% sp.Speak(text);

%% 停止记录公共窗口输出的数据并保存
diary off;








%%
end
