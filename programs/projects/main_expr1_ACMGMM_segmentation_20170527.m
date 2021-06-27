%% 用于分割的主程序
% 实验1：全监督ACMGMM的实验系列：ACMGMM、CV、GMM、LIF处理 circleACMGMM 5-28挑出来\需要出中间运行结果 的那些图像。

%% 注意事项：
% 手动把文件夹“ACM+GMM”设为当前文件夹。手动将里面的文件夹“functions”、“projects”及其子文件添加入路径。


%% 预处理
clear all;
close all;
clc;
diary off;
addpath( genpath( '.\functions' ) ); %添加当前路径下的所有文件夹以及子文件夹
addpath( genpath( '.\projects' ) ); %添加当前路径下的所有文件夹以及子文件夹
addpath( genpath( '.\tools' ) ); %添加当前路径下的所有文件夹以及子文件夹

%% segmentation

% init
clear;
setSegmentationArgsFirst;
initArgsACMGMM;
initArgsCV;
initArgsGMM;
initArgsLIF;

%% 非逐代运行
Args.initMethod = 'circle+ACMGMM';
Args.proportionPixelsToEndLoop = 0.00010;
Args.numIteration_outer = 1000;
Args.isNotWriteDataAtAll = 'yes' ; % 程序运行过程中产生的结果数据是否保存，如果是，那么就不保存结果数据，但是最终的二值图图像还是会保存的。默认 'yes'
Args.foldername_EachImageBaseFolder = '.\data\resources\circleACMGMM 5-28挑出来\需要出中间运行结果的';
Args.foldername_ResultsBaseFolder = '.\data\segmentations\circleACMGMM 5-28挑出来\需要出中间运行结果的\收敛';
Args.evolutionMethod='ACMGMM';
Args = setEvolutionMethod(Args, Args.evolutionMethod);
segmentation_func(Args);
Args.evolutionMethod='CV';
Args = setEvolutionMethod(Args, Args.evolutionMethod);
segmentation_func(Args);
Args.evolutionMethod='GMM';
Args = setEvolutionMethod(Args, Args.evolutionMethod);
segmentation_func(Args);
Args.evolutionMethod='LIF';
Args = setEvolutionMethod(Args, Args.evolutionMethod);
segmentation_func(Args);


% %% 逐代运行
% Args.initMethod = 'circle+ACMGMM';
% Args.proportionPixelsToEndLoop = 0.00010;
% Args.numIteration_outer = 30;
% Args.isNotWriteDataAtAll = 'no' ; % 程序运行过程中产生的结果数据是否保存，如果是，那么就不保存结果数据，但是最终的二值图图像还是会保存的。默认 'yes'
% Args.foldername_EachImageBaseFolder = '.\data\resources\circleACMGMM 5-28挑出来\需要出中间运行结果的';
% Args.foldername_ResultsBaseFolder = '.\data\segmentations\circleACMGMM 5-28挑出来\需要出中间运行结果的\逐代';
% Args.evolutionMethod='ACMGMM';
% Args = setEvolutionMethod(Args, Args.evolutionMethod);
% segmentation_func(Args);
% Args.evolutionMethod='CV';
% Args = setEvolutionMethod(Args, Args.evolutionMethod);
% segmentation_func(Args);
% Args.evolutionMethod='GMM';
% Args = setEvolutionMethod(Args, Args.evolutionMethod);
% segmentation_func(Args);
% Args.evolutionMethod='LIF';
% Args = setEvolutionMethod(Args, Args.evolutionMethod);
% segmentation_func(Args);







% % segmentation
% for evolutionMethod=['ACMGMM';'CV';'GMM';'LIF']
% 	segmentation_func(evolutionMethod);
% end

% end


%% calculation
% % init
% clear;
% setEvaluationCalculateArgsFirst
% 
% copyfile('\data\segmentations\circleACMGMM_epsilon0.5_sigma0.3\*','\data\calculation\circleACMGMM_epsilon0.5_sigma0.3\*')
% 
% % calculation
% Args.folderpath_EachImageBaseFolder = '.\data\resources\circleACMGMM_epsilon0.5_sigma0.3'; % 用于计算文件的结构体 EachImage 的基本路径
% Args.folderpath_ResultsBaseFolder = '.\data\calculation\circleACMGMM_epsilon0.5_sigma0.3'; % 用于计算文件的结构体 Results 的基本路径。
% evaluationCalculate_func(Args);
% 
% Args.folderpath_EachImageBaseFolder = '.\data\resources\circle'; % 用于计算文件的结构体 EachImage 的基本路径
% Args.folderpath_ResultsBaseFolder = '.\data\calculation\circle'; % 用于计算文件的结构体 Results 的基本路径。
% evaluationCalculate_func(Args);

















